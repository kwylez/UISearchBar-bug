//
//  MenuViewController.m
//  SearchBarBug
//
//  Created by Mouhcine El Amine on 07/01/14.
//  Copyright (c) 2014 Mouhcine El Amine. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"

static CGFloat const STANDARD_TOP_OFFSET = 64.0f;
static CGFloat const SEARCH_BAR_HEIGHT   = 44.0f;


@interface MenuViewController () <UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  self.view.backgroundColor = [UIColor blueColor];
	[self.view addSubview:self.tableView];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillDisappear:)
                                               name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillAppear:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
}

- (void)keyboardWillAppear:(NSNotification *)note
{
  [self.sidePanelController setCenterPanelHidden:YES
                                        animated:YES
                                        duration:[[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
  self.searchBar.showsCancelButton = YES;
}

- (void)keyboardWillDisappear:(NSNotification *)note
{
  [self.searchBar setShowsCancelButton:NO animated:NO];
  
  [self.sidePanelController setCenterPanelHidden:NO
                                        animated:NO
                                        duration:[[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillLayoutSubviews {
  
  [super viewWillLayoutSubviews];
  
  self.searchBar.frame = CGRectMake(0.0f, [[UIApplication sharedApplication] statusBarFrame].size.height, self.view.frame.size.width, SEARCH_BAR_HEIGHT);
}

#pragma mark - UITableViewDataSource

- (UITableView *)tableView
{
  if (!_tableView) {
    CGRect frame = CGRectMake(0.0f,
                              STANDARD_TOP_OFFSET,
                              self.view.bounds.size.width,
                              self.view.bounds.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height);
    _tableView = [[UITableView alloc] initWithFrame:frame
                                              style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.dataSource = self;
    [self addSearchBar];
  }
  return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MenuCellIdentifier = @"MenuCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuCellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:MenuCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  cell.textLabel.text = [NSString stringWithFormat:@"Menu item %i", indexPath.row];
  return cell;
}

#pragma mark - Search bar

- (UISearchBar *)searchBar
{
  if (!_searchBar) {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, [[UIApplication sharedApplication] statusBarFrame].size.height, self.view.frame.size.width, SEARCH_BAR_HEIGHT)];
    _searchBar.translucent = NO;
    _searchBar.barTintColor = [UIColor grayColor];
    _searchBar.clipsToBounds = YES;
    _searchBar.delegate = self;
  }
  return _searchBar;
}

- (void)addSearchBar
{
  
  [self.view addSubview:self.searchBar];
  
  self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar
                                                            contentsController:self];
  self.searchController.searchResultsDataSource = self;
}

@end
