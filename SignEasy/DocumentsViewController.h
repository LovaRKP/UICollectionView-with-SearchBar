//
//  DocumentsViewController.h
//  SignEasy
//
//  Created by Techno on 10/24/15.
//  Copyright © 2015 Techno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentsViewController : UIViewController<UICollectionViewDelegate, UISearchBarDelegate>
{
    NSArray *collectionImages;
}

@property(nonatomic,retain) IBOutlet UICollectionView *myCollectionVw;

//SEARCH BAR
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar2;
@property (nonatomic, assign) bool isFiltered;

@end
