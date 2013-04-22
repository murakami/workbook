//
//  SongsViewController.m
//  AudioPlayer
//
//  Created by 村上 幸雄 on 13/04/21.
//  Copyright (c) 2013年 Bitz Co., Ltd. All rights reserved.
//

//#import <AVFoundation/AVFoundation.h>
//#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SongsViewController.h"

@interface SongsViewController ()
@property (nonatomic, strong) NSMutableArray            *songsList;
@property (nonatomic, strong) MPMusicPlayerController   *musicPlayerController;
@end

@implementation SongsViewController

@synthesize songsList = _songsList;
@synthesize musicPlayerController = _musicPlayerController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.songsList = [[NSMutableArray alloc] init];
    self.musicPlayerController = [MPMusicPlayerController iPodMusicPlayer];
    
    MPMediaQuery    *songsQuery = [MPMediaQuery songsQuery];
    NSArray         *mediaItems = [songsQuery items];
    for (MPMediaItem *mediaItem in mediaItems) {
        NSURL   *URL = (NSURL*)[mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
        if (URL) {
            NSString    *title = (NSString*)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
            [self.songsList addObject:title];
        }
    }
    
    /*
    for (MPMediaItem *mediaPlaylist in collections) {
        for (MPMediaItem *mediaItem in [mediaPlaylist items]) {
            NSArray* songArray = nil;
            songArray = [NSArray arrayWithObjects:
                             [mediaItem valueForProperty:
                              MPMediaItemPropertyPersistentID],
                             [mediaItem valueForProperty:
                              MPMediaItemPropertyTitle],
                             [mediaItem valueForProperty:
                              MPMediaItemPropertyArtist],
                             [mediaItem valueForProperty:
                              MPMediaItemPropertyAlbumTitle],
                             nil];
            [self.songsList addObject:songArray];
        }
    }
     */
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
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSString    *title = [self.songsList objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
