//
//  DocumentsViewController.m
//  SignEasy
//
//  Created by Techno on 10/24/15.
//  Copyright © 2015 Techno. All rights reserved.
//

#import "DocumentsViewController.h"
#import "CollectionReusableView.h"
#import "AFHTTPRequestOperationManager.h"
#include <CommonCrypto/CommonDigest.h>
#import "CollectionViewCell.h"

@interface DocumentsViewController ()

{
    NSMutableDictionary *dictonary;
    NSArray *documentsSectionTitles;
    NSMutableArray *countArray;
    NSArray *sectionDocuments;
    UIActivityIndicatorView *spinner;
    
}
@property (weak, nonatomic) IBOutlet  UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *createdLab;
@property (weak, nonatomic) IBOutlet  UILabel *modifiedLab;

@end

@implementation DocumentsViewController

@synthesize myCollectionVw;
//search bar
@synthesize filteredTableData;
@synthesize searchBar2;
@synthesize isFiltered;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = self.view.center;
    spinner.color = [UIColor redColor];
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    
    searchBar2.delegate = (id)self;
    
    searchBar2.placeholder = @"Search documents";
    
    self.navigationItem.title = @"All Documents";
    _infoView.hidden = YES;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    documentsSectionTitles = [[NSArray alloc]init];
    collectionImages = [[NSArray alloc]init];
    countArray = [[NSMutableArray alloc]init];
    sectionDocuments = [[NSArray alloc]init];
    
    [self GetingDattaFromServer];
}

// Add this Method
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.myCollectionVw reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    NSInteger sectionCount;
    
    sectionCount =[documentsSectionTitles count];
    
    if(isFiltered)
    {
        sectionCount = 1;
        return sectionCount;
        
    }else{
        return sectionCount;
    }
    return sectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger rowCount;
    
    NSString *sectionTitle = [documentsSectionTitles objectAtIndex:section];
    NSArray *sectionAnimals = [dictonary objectForKey:sectionTitle];
    
    if(self.isFiltered)
        rowCount = filteredTableData.count;
    else
        rowCount =  [sectionAnimals count];
    return rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *sectionTitle = [documentsSectionTitles objectAtIndex:indexPath.section];
    sectionDocuments = [dictonary objectForKey:sectionTitle];
    
    NSString *str1;
    
    [cell.infobutton setBackgroundImage:[UIImage imageNamed:@"InfoButton.png"]
                               forState:UIControlStateNormal];
    
    [cell.infobutton addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.infobutton.tag = indexPath.row;
    
    if(isFiltered)
    {
        str1 = [filteredTableData objectAtIndex:indexPath.row];
        
    }
    else
    {
        //NSLog(@"Not Sorted ...");
        //str1 = [collectionImages objectAtIndex:indexPath.row];
        
        str1 =[[sectionDocuments objectAtIndex:indexPath.row]objectForKey:@"name"];
    }
    
    NSString *imgNameSr = [NSString stringWithFormat:@"%@",str1];
    cell.label1.text = imgNameSr;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
    
    NSString *nameSelected;
    
    if(isFiltered)
    {
        nameSelected = [filteredTableData objectAtIndex:[indexPath row]];
    }
    else
    {
        nameSelected = [collectionImages objectAtIndex:[indexPath row]];
    }
    
    NSLog(@"nameSelected: %@ ...", nameSelected);
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

-(void)checkButtonTapped:(id)sender {
    
    int rowIteam = (int)[sender tag];
    
    
    
    NSString *nameSelected;
    
    if(isFiltered)
    {
        nameSelected = [filteredTableData objectAtIndex:rowIteam];
        
        NSMutableArray *filteraddDict = [[NSMutableArray alloc]init];
        
        for (int k = 0; k < dictonary.count; k++) {
            
            
            NSString *sectionTitle = [documentsSectionTitles objectAtIndex:k];
            NSArray *sectionAnimals = [dictonary objectForKey:sectionTitle];
            
            for (int j = 0 ; j < sectionAnimals.count ; j++) {
                
                NSString *filteredName = [[sectionAnimals objectAtIndex:j]objectForKey:@"name"];
                
                if (nameSelected ==filteredName ) {
                    
                    [filteraddDict addObject:[sectionAnimals objectAtIndex:j]];
                    
                }
                
            }
            
            
        }
        
        //Showing Info of Cell
        
        NSString *lastModified = [[filteraddDict objectAtIndex:0]objectForKey:@"last_modified_time"];
        NSString *created = [[filteraddDict objectAtIndex:0]objectForKey:@"created_time"];
        
        // convert unixTime Stamp to nsdata
        
        double unixTimeStamp = [lastModified doubleValue];
        NSTimeInterval _interval=unixTimeStamp;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
        [_formatter setLocale:[NSLocale currentLocale]];
        [_formatter setDateFormat:@"MMM dd, yyyy-h:mm"];
        NSString *lastmodifieddate=[_formatter stringFromDate:date];
        
        
        double unixTimeStamp1 = [created doubleValue];
        NSTimeInterval _interval1=unixTimeStamp1;
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:_interval1];
        NSDateFormatter *_formatter1=[[NSDateFormatter alloc]init];
        [_formatter1 setLocale:[NSLocale currentLocale]];
        [_formatter1 setDateFormat:@"MMM dd, yyyy-h:mm"];
        NSString *createdDate=[_formatter1 stringFromDate:date1];
        
        _infoView.hidden = NO; // make the view visibule
        
        self.nameLab.numberOfLines = 0;
        self.nameLab.text = nameSelected;
        [self.nameLab sizeToFit];
        self.createdLab.text = createdDate;
        self.modifiedLab.text = lastmodifieddate;
        
    }
    else
    {
        nameSelected = [collectionImages objectAtIndex:rowIteam];
        
        //Showing Info of Cell
        NSDictionary *infoDic = [sectionDocuments objectAtIndex:rowIteam];
        NSLog(@"infodictionary ===%@",infoDic);
        
        NSString *lastModified = [[sectionDocuments objectAtIndex:rowIteam]objectForKey:@"last_modified_time"];
        NSString *created = [[sectionDocuments objectAtIndex:rowIteam]objectForKey:@"created_time"];
        
        // convert unixTime Stamp to nsdata
        
        double unixTimeStamp = [lastModified doubleValue];
        NSTimeInterval _interval=unixTimeStamp;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
        [_formatter setLocale:[NSLocale currentLocale]];
        [_formatter setDateFormat:@"MMM dd, yyyy-h:mm"];
        NSString *lastmodifieddate=[_formatter stringFromDate:date];
        
        
        double unixTimeStamp1 = [created doubleValue];
        NSTimeInterval _interval1=unixTimeStamp1;
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:_interval1];
        NSDateFormatter *_formatter1=[[NSDateFormatter alloc]init];
        [_formatter1 setLocale:[NSLocale currentLocale]];
        [_formatter1 setDateFormat:@"MMM dd, yyyy-h:mm"];
        NSString *createdDate=[_formatter1 stringFromDate:date1];
        
        _infoView.hidden = NO; // make the view visibule
        
        self.nameLab.numberOfLines = 0;
        self.nameLab.text = nameSelected;
        [self.nameLab sizeToFit];
        self.createdLab.text = createdDate;
        self.modifiedLab.text = lastmodifieddate;
        
    }
    
    
    
}


- (IBAction)cancelPressed:(id)sender {
    
    
    _infoView.hidden = YES;
    
}


//*****************
// SEARCH BAR
//*****************

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    //NSLog(@"searchBar ... text.length: %d", text.length);
    
    if(text.length == 0)
    {
        isFiltered = FALSE;
        [searchBar resignFirstResponder];
    }
    else
    {
        isFiltered = true;
        filteredTableData = [[NSMutableArray alloc] init];
        
        
        for (NSString* item in collectionImages)
        {
            //case insensative search - way cool
            if ([item rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [filteredTableData addObject:item];
            }
            
        }
    }//end if-else
    
    [self.myCollectionVw reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //User hit Search button on Keyboard
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
    isFiltered = FALSE;
    [self.myCollectionVw reloadData];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    NSString *headerStr = [documentsSectionTitles objectAtIndex:indexPath.section];
    
    int mapX = (int)[[countArray objectAtIndex:indexPath.section] integerValue];
    
    
    
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        NSString *title = [[NSString alloc]initWithFormat:@"%@ #%i",headerStr, mapX];
        headerView.myLabelView.text = title;
        
        reusableview = headerView;
    }
    
    return reusableview;
}

// GettingData from server

-(void)GetingDattaFromServer{
    
    // Converting 64 encoding password
    
    NSString *email=@"signeasytask2@gmail.com";
    
    // Create NSData object
    NSData *nsdata = [@"signeasytask2"
                      dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    // Print the Base64 encoded string
    
    
    NSString *password = base64Encoded;
    
    password=[self sha256HashFor: password];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:email password:password];
    
    [manager GET:@"https://api.getsigneasy.com/v4/files" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        dictonary = responseObject;
        
        //  NSString *countvalue = [dictonary objectForKey:@"count"];
        
        dictonary = [dictonary mutableCopy];
        
        [dictonary removeObjectForKey:@"count"];
        
        NSArray *keys  = [dictonary allKeys];
        NSArray *values = [dictonary allValues];
        
        
        documentsSectionTitles = [dictonary allKeys];
        
        
        NSMutableArray *finalArray = [[NSMutableArray alloc]init];
        
        for (int i = 0 ; i < values.count; i++) {
            
            NSMutableArray *temp = [[values objectAtIndex:i]objectForKey:@"files"];
            
            NSString *countStr = [[values objectAtIndex:i]objectForKey:@"count"];
            
            int values = [countStr intValue];
            
            [countArray addObject:[NSNumber numberWithInt:values]];
            
            [finalArray addObject:temp];
            
        }
        dictonary = [NSMutableDictionary dictionaryWithObjects: finalArray forKeys: keys];
        
        // getting all documents names
        
        NSMutableArray *imagesarry = [[NSMutableArray alloc]init];
        
        for (int r = 0; r< keys.count; r++) {
            
            NSString *sectionTitle = [documentsSectionTitles objectAtIndex:r];
            NSArray *sectionAnimals = [dictonary objectForKey:sectionTitle];
            
            for (int m = 0; m < [sectionAnimals count]; m++) {
                if ([sectionAnimals count] == 0) {
                    
                }else{
                    
                    NSString *document = [[sectionAnimals objectAtIndex:m]objectForKey:@"name"];
                    
                    [imagesarry addObject:document];
                    
                }
                
            }
            
        }
        
        collectionImages = imagesarry;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.myCollectionVw reloadData];
            [spinner stopAnimating];
            
            
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
-(NSString*)sha256HashFor:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


@end
