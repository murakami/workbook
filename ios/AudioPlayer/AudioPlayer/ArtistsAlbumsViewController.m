//
//  ArtistsAlbumsViewController.m
//  AudioPlayer
//
//  Created by 村上幸雄 on 2014/05/04.
//  Copyright (c) 2014年 Bitz Co., Ltd. All rights reserved.
//

#import "Document.h"
#import "DetailViewController.h"
#import "ArtistsAlbumsViewController.h"

@interface ArtistsAlbumsViewController ()

@end

@implementation ArtistsAlbumsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSDictionary *artist = [[Document sharedInstance].artists objectAtIndex:self.artistsIndex];
    NSArray *albums = [artist objectForKey:@"albums"];
    return albums.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *artist = [[Document sharedInstance].artists objectAtIndex:self.artistsIndex];
    NSArray *albums = [artist objectForKey:@"albums"];
    NSDictionary    *albumDict = [albums objectAtIndex:section];
    NSArray *songs = [albumDict objectForKey:@"songs"];
    return songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArtistsAlbumsCell" forIndexPath:indexPath];
    
    NSDictionary *artist = [[Document sharedInstance].artists objectAtIndex:self.artistsIndex];
    NSArray *albums = [artist objectForKey:@"albums"];
    NSDictionary    *albumDict = [albums objectAtIndex:indexPath.section];
    NSArray *songs = [albumDict objectForKey:@"songs"];
    cell.textLabel.text = [[songs objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *artist = [[Document sharedInstance].artists objectAtIndex:self.artistsIndex];
    NSArray *albums = [artist objectForKey:@"albums"];
    NSDictionary    *albumDict = [albums objectAtIndex:section];
    return [albumDict objectForKey:@"album title"];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DBGMSG(@"%s", __func__);
    if ([[segue identifier] isEqualToString:@"toDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *artist = [[Document sharedInstance].artists objectAtIndex:self.artistsIndex];
        NSArray *albums = [artist objectForKey:@"albums"];
        NSDictionary    *albumDict = [albums objectAtIndex:indexPath.section];
        NSArray *songs = [albumDict objectForKey:@"songs"];
        NSDictionary *song = [songs objectAtIndex:indexPath.row];
        
        DetailViewController    *detailViewController = [segue destinationViewController];
        detailViewController.dict = song;
        DBGMSG(@"%s, song:%@", __func__, song);
    }
}

@end
