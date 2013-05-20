//
//  SongsViewController.m
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/04/21.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "Connector.h"
#import "DetailViewController.h"
#import "SongsViewController.h"

@interface SongsViewController ()
@property (strong, nonatomic) NSMutableArray            *songsList;
@property (strong, nonatomic) MPMusicPlayerController   *musicPlayerController;
@property (strong, nonatomic) NSMutableDictionary       *dict;
- (void)_init;
- (void)_updateBrowserItems:(NSMutableArray *)newItems;
- (void)_connectorDidFinishUpdateIPodLibrary:(NSNotification*)notification;
@end

@implementation SongsViewController

@synthesize songsList = _songsList;
@synthesize musicPlayerController = _musicPlayerController;
@synthesize dict = _dict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_connectorDidFinishUpdateIPodLibrary:)
                                                 name:ConnectorDidFinishUpdateIPodLibrary
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ConnectorDidFinishUpdateIPodLibrary
                                                  object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.songsList = [[NSMutableArray alloc] init];
    self.musicPlayerController = [MPMusicPlayerController iPodMusicPlayer];
    
    [[Connector sharedConnector] updateIPodLibrary:kAssetBrowserSourceTypeSongs];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    self.songsList = nil;
    self.musicPlayerController = nil;
    self.dict = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.dict = [self.songsList objectAtIndex:indexPath.row];
        DetailViewController    *detailViewController = [segue destinationViewController];
        detailViewController.dict = self.dict;
        DBGMSG(@"%s, dict:%@", __func__, self.dict);
    }
}

- (void)_updateBrowserItems:(NSMutableArray*)newItems
{
    self.songsList = newItems;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.songsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SongsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString    *title = [[self.songsList objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.textLabel.text = title;
    
    return cell;
}

#pragma mark - Table view delegate

#pragma mark -
#pragma mark iPod Library

- (void)_connectorDidFinishUpdateIPodLibrary:(NSNotification*)notification
{
    AssetBrowserResponseParser  *parser = [notification.userInfo objectForKey:@"parser"];
    if (parser.state == kAssetBrowserCodeCancel) {
        return;
    }
    
    if (kAssetBrowserSourceTypeSongs == parser.sourceType) {
        [self _updateBrowserItems:parser.assetBrowserItems];
    }
}

@end
