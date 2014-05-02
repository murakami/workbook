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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
