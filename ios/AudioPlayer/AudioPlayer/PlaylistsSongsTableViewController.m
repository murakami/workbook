//
//  PlaylistsSongsTableViewController.m
//  AudioPlayer
//
//  Created by 村上幸雄 on 2014/05/01.
//  Copyright (c) 2014年 Bitz Co., Ltd. All rights reserved.
//

#import "Document.h"
#import "DetailViewController.h"
#import "PlaylistsSongsTableViewController.h"

@interface PlaylistsSongsTableViewController ()

@end

@implementation PlaylistsSongsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    DBGMSG(@"%s", __func__);
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *playlist = [[Document sharedInstance].playlists objectAtIndex:self.playlistsIndex];
    NSArray *songs = [playlist objectForKey:@"songs"];
    return songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaylistsSongsCell"
                                                            forIndexPath:indexPath];
    
    NSDictionary *playlist = [[Document sharedInstance].playlists objectAtIndex:self.playlistsIndex];
    NSArray *songs = [playlist objectForKey:@"songs"];
    cell.textLabel.text = [[songs objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DBGMSG(@"%s", __func__);
    if ([[segue identifier] isEqualToString:@"toDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *playlist = [[Document sharedInstance].playlists objectAtIndex:self.playlistsIndex];
        NSArray *songs = [playlist objectForKey:@"songs"];
        NSDictionary *song = [songs objectAtIndex:indexPath.row];
        
        DetailViewController    *detailViewController = [segue destinationViewController];
        detailViewController.dict = song;
        DBGMSG(@"%s, song:%@", __func__, song);
    }
}

@end
