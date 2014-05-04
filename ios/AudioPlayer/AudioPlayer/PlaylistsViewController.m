//
//  PlaylistsViewController.m
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/04/21.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "Document.h"
#import "Connector.h"
#import "PlaylistsSongsTableViewController.h"
#import "PlaylistsViewController.h"

@interface PlaylistsViewController ()
- (void)_init;
@end

@implementation PlaylistsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    DBGMSG(@"%s", __func__);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    DBGMSG(@"%s", __func__);
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    DBGMSG(@"%s", __func__);
    self = [super initWithStyle:style];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    DBGMSG(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_connectorDidFinishUpdateIPodLibrary:)
                                                 name:ConnectorDidFinishUpdateIPodLibrary
                                               object:nil];
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_connectorDidFinishUpdateIPodLibrary:)
                                                 name:ConnectorDidFinishUpdateIPodLibrary
                                               object:nil];
}

- (void)viewDidLoad
{
    DBGMSG(@"%s", __func__);
    [super viewDidLoad];
    
    [[Connector sharedConnector] updateIPodLibrary:kAssetBrowserSourceTypePlaylists];
}

- (void)viewWillAppear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DBGMSG(@"%s", __func__);
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    DBGMSG(@"%s", __func__);
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    DBGMSG(@"%s", __func__);
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Document sharedInstance].playlists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlaylistsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[[Document sharedInstance].playlists objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    return cell;
}

#pragma mark - Table view delegate

#pragma mark -
#pragma mark iPod Library

- (void)_connectorDidFinishUpdateIPodLibrary:(NSNotification*)notification
{
    DBGMSG(@"%s", __func__);
    AssetBrowserResponseParser  *parser = [notification.userInfo objectForKey:@"parser"];
    if (parser.state == kAssetBrowserCodeCancel) {
        return;
    }
    
    if (kAssetBrowserSourceTypePlaylists == parser.sourceType) {
        [Document sharedInstance].playlists = parser.assetBrowserItems;
        [self.tableView reloadData];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DBGMSG(@"%s", __func__);
    if ([[segue identifier] isEqualToString:@"toSongs"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PlaylistsSongsTableViewController   *songsViewController = [segue destinationViewController];
        songsViewController.playlistsIndex= indexPath.row;
        DBGMSG(@"%s, playlists index:%d", __func__, (int)indexPath.row);
    }
}

@end
