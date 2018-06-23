//
//  ItemViewController.m
//  QRApp
//
//  Created by Ricardo Rojas on 06/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "ItemViewController.h"
#import "CoreDataManager.h"
#import "TableViewCell.h"
#import "RegisterProductViewController.h"
#import "AuditoriaViewController.h"


@interface ItemViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UISearchBarDelegate>
{
    ProductModel * productToSend;
}

@property (nonatomic,strong ) NSMutableArray * products;
@property (nonatomic, weak) IBOutlet UITableView * tb;

@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];

 
}

-(void)viewDidAppear:(BOOL)animated
{
    _products = [[CoreDataManager getProductModel] mutableCopy];

    UINib * cellnib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tb registerNib:cellnib forCellReuseIdentifier:@"cell"];
    [_tb reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _products.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    
    TableViewCell * cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    ProductModel * p = [_products objectAtIndex:indexPath.row];
    
    cell.descriptionn.text = p.descrip;
    cell.idProduct.text = p.idProduct;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    productToSend = [_products objectAtIndex:indexPath.row];
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Inicio Ispección" message:@"Usted esta apunto de iniciar inspección ?" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
    
    [alert show];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSManagedObject *productData = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context];
    

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:productData];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove device from table view
        [_products removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   [self performSegueWithIdentifier:@"Auditoria" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Auditoria"]) {
        AuditoriaViewController * VC = (AuditoriaViewController *)[segue destinationViewController];
        VC.pdroduct = productToSend;
    }
}
@end
