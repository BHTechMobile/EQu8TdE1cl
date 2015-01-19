//
//  FriendsScreenViewController.m
//  9HugMoment
//

#import "FriendsScreenViewController.h"
#import "FriendTableViewCell.h"
#import "FriendRequestTableViewCell.h"
#import "FriendRecommendationsTableViewCell.h"
#import "FriendHeaderView.h"

typedef NS_ENUM(NSInteger, FriendsSection)
{
    FriendsSectionRequest,
    FriendsSectionFriend,
    FriendsSectionRecommendation,
    FriendsSectionMaximum
};

typedef NS_ENUM(NSInteger, TypeToShowFriend)
{
    TypeToShowFriendAlphabet,
    TypeToShowFriendRecent
};

#define HEIGHT_HEADER_VIEW_FRIEND_REQUEST 0
#define HEIGHT_HEADER_VIEW_FRIEND 36
#define HEIGHT_HEADER_VIEW_FRIEND_RECOMMENDATION 36

#define HEIGHT_TABLE_CELL_FRIEND_REQUEST 70
#define HEIGHT_TABLE_CELL_FRIEND 70
#define HEIGHT_TABLE_CELL_FRIEND_RECOMMENDATION 70
#define PADDING_HEADER_TABLE_VIEW 20

#define IDENTIFIER_FRIEND_TABLE_VIEW_CELL @"identifierFriendCell"
#define IDENTIFIER_FRIEND_REQUEST_TABLE_VIEW_CELL @"identifierFriendRequestCell"
#define IDENTIFIER_FRIEND_RECOMMENDATIONS_TABLE_VIEW_CELL @"identifierFriendRecommendationsCell"

#define TEXT_TITLE_FRIEND_HEADER_SECTION @"Friend"
#define TEXT_TITLE_FRIEND_RECOMMENDATIONS_HEADER_SECTION @"Recommendations"

@interface FriendsScreenViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeToShowDataSegment;
@property (weak, nonatomic) IBOutlet UITableView *alphabetTableView;
@property (weak, nonatomic) IBOutlet UITableView *recentTableView;

- (IBAction)addFriendAction:(id)sender;
- (IBAction)changeTypeToShowData:(id)sender;

@end

@implementation FriendsScreenViewController

#pragma mark - FriendsScreenViewController management

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - Actions

- (IBAction)addFriendAction:(id)sender {
    //TODO: Add Friend
}

- (IBAction)changeTypeToShowData:(id)sender {
    if (_typeToShowDataSegment.selectedSegmentIndex == TypeToShowFriendAlphabet) {
        _alphabetTableView.hidden = NO;
        _recentTableView.hidden = YES;
    }
    else
    {
        _alphabetTableView.hidden = YES;
        _recentTableView.hidden = NO;
    }
}

#pragma mark - Custom Methods

#pragma mark - TableView delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CGFloat result = 0;
    //TODO: Temp data need update
    if (section == FriendsSectionRequest)
    {
        result = 2;
    }
    else if (section == FriendsSectionFriend)
    {
        result = 3;
    }
    else if (section == FriendsSectionRecommendation)
    {
        result = 7;
    }
    
    return result;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return FriendsSectionMaximum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = 0;
    if (indexPath.section == FriendsSectionRequest)
    {
        result = HEIGHT_TABLE_CELL_FRIEND_REQUEST;
    }
    else if (indexPath.section == FriendsSectionFriend)
    {
        result = HEIGHT_TABLE_CELL_FRIEND;
    }
    else if (indexPath.section == FriendsSectionRecommendation)
    {
        result = HEIGHT_TABLE_CELL_FRIEND_RECOMMENDATION;
    }
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int result = 0;
    if (section == FriendsSectionRequest)
    {
        result = HEIGHT_HEADER_VIEW_FRIEND_REQUEST;
    }
    else if (section == FriendsSectionFriend)
    {
        result = HEIGHT_HEADER_VIEW_FRIEND;
    }
    else if (section == FriendsSectionRecommendation)
    {
        result = HEIGHT_HEADER_VIEW_FRIEND_RECOMMENDATION;
    }
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    int result = 0;
    if (section == FriendsSectionRecommendation) {
        result = HALF_OF(HEIGHT_RECORD_BUTTON_MESSAGE_DETAILS_VIEW_CONTROLLER);
    }
    return result;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor whiteColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FriendHeaderView *headerView = [[FriendHeaderView alloc] initWithFrame:CGRectZero];
    CGRect headerFrame = CGRectMake(0, 0, tableView.frame.size.width, HEIGHT_HEADER_VIEW_FRIEND);
    headerView.frame = headerFrame;
    if (section == FriendsSectionFriend) {
        headerView.titleHeaderLabel.text = TEXT_TITLE_FRIEND_HEADER_SECTION;
    }
    else if (section == FriendsSectionRecommendation)
    {
        headerView.titleHeaderLabel.text = TEXT_TITLE_FRIEND_RECOMMENDATIONS_HEADER_SECTION;
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellResult;
    if (indexPath.section == FriendsSectionRequest)
    {
        cellResult = [self friendRequestCellForRowAtTableView:tableView withIndexPath:indexPath];
    }
    else if (indexPath.section == FriendsSectionFriend)
    {
        cellResult = [self friendCellForRowAtTableView:tableView withIndexPath:indexPath];
    }
    else
    {
        cellResult = [self friendRecommendationsCellForRowAtTableView:tableView withIndexPath:indexPath];
    }
    
    return cellResult;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: Selecet Friend add row
}

#pragma mark - TableView Cell & Data

- (FriendTableViewCell *)friendCellForRowAtTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath
{
    FriendTableViewCell *cell = (FriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_FRIEND_TABLE_VIEW_CELL];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:[[FriendTableViewCell class] description] bundle:nil] forCellReuseIdentifier:IDENTIFIER_FRIEND_TABLE_VIEW_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_FRIEND_TABLE_VIEW_CELL];
    }
    //TODO: Add data
    return cell;
}

- (FriendRequestTableViewCell *)friendRequestCellForRowAtTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath
{
    FriendRequestTableViewCell *cell = (FriendRequestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_FRIEND_REQUEST_TABLE_VIEW_CELL];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:[[FriendRequestTableViewCell class] description] bundle:nil] forCellReuseIdentifier:IDENTIFIER_FRIEND_REQUEST_TABLE_VIEW_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_FRIEND_REQUEST_TABLE_VIEW_CELL];
    }
    //TODO: Add data
    return cell;
}

- (FriendRecommendationsTableViewCell *)friendRecommendationsCellForRowAtTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath
{
    FriendRecommendationsTableViewCell *cell = (FriendRecommendationsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_FRIEND_RECOMMENDATIONS_TABLE_VIEW_CELL];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:[[FriendRecommendationsTableViewCell class] description] bundle:nil] forCellReuseIdentifier:IDENTIFIER_FRIEND_RECOMMENDATIONS_TABLE_VIEW_CELL];
        cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_FRIEND_RECOMMENDATIONS_TABLE_VIEW_CELL];
    }
    
    //TODO: Add data
    return cell;
}

@end
