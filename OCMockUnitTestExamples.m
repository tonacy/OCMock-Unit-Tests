// 
//   OCMock Testing of a View Controller
//  Tony Llongueras 2012
//


/*      This File is meant to provide some examples on how to 
 *          test certain scenarios one would encounter while 
 *          unit testing a view controller in Obj-C
 *          Particularly when using Mock objects.
 *
 *      Make sure you're using SenTestingKit and OCMock 
 *          (that can be downloaded @ http://ocmock.org/ )
 */

//A quick set up and tear down for the modelController property
- (void)setUp {
    self.modelController = [[ViewController alloc] init];
}

- (void)tearDown {
    [modelController_ release], modelController_ = nil;
}


/*
 *  This Unit test mocks up a viewController and one of it's views.
 *  
 *  We expect one of the view's functions to be called and verify.
 */
- (void)testViewWillAppearCallsAFunction {
    SomeViewController * controller = self.modelController;
    
    OCMockObject * mockController = [OCMockObject partialMockForObject:controller];
    OCMockObject * mockView = [OCMockObject mockForClass:[UIView class]];
    
    [[[mockController expect] andReturn:mockView] view];
    [[mockView expect] aFunction];
    
    [controller viewWillAppear:YES];
    
    [mockController verify];
    [mockView verify];
}

/*
 *  Esssentially, the opposite of the test above.
 *  We reject, instead of expect,  the view's function to be called.
 */
- (void)testViewWillAppearDoesNotCallDeselectWithNoIndexPathSelected {
    SomeViewController * controller = self.modelController;
    
    OCMockObject * mockController = [OCMockObject partialMockForObject:controller];
    OCMockObject * mockView = [OCMockObject mockForClass:[UIView class]];

    [[[mockController expect] andReturn:mockView] view];
    [[mockView reject] aFunction];

    [controller viewWillAppear:YES];

    [mockController verify];
    [mockView verify];
}

/*
 * Simply expect one of the controller's functions be called when calling another function
 *
 *  This can be easily changed to reject the same function by changing 'expect' to 'reject'
 *
 */
- (void)testRequestForTableModelLoadsTheTableModel {
    OCMockObject * mockController = [OCMockObject partialMockForObject:self.controller];
    
    [[mockController expect] someFunction];
    
    [self.modelController anotherFunction];
    
    [mockController verify];
}

/*
 *  This example shows how to test a block.
 *
 *  I used a simple table model for this example
 *
 */
- (void)testCellAllocationCallsRowAllocationBlock {
    ViewController *controller = self.modelController;
    
    OCMockObject * mockString = [OCMockObject mockForClass:[NSString class]];
    [[mockString expect] length];
    
    TableSection *section = [TableSection section];
    TableRow *row = [TableRow row];
    [row setCellClass:[TableViewCell class]];
    [row setCellData:@"Test"];
    
    [row setAllocateBlock:^(TableViewCell * cell) {
        [(NSString *)mockString length];
    }];
    
    [section addRow:row];
    
    TableModel *model = [[TableModel alloc] init];
    [controller setTableModel:model];
    [controller.tableModel addSection:section];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [controller tableView:nil cellForRowAtIndexPath:path];
    
    [mockString verify];
    
    [model release];
}


