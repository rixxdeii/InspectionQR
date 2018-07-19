//
//  PrintViewController.m
//  FederalMogulM
//
//  Created by Ricardo Rojas on 16/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "PrintViewController.h"
#import "QRCodeGenerator.h"
#import "QRCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
@interface PrintViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray * data;
    NSInteger  noPalets;
    NSInteger  nopaquetes;
}
@property (weak, nonatomic) IBOutlet UICollectionView *coillectionView;

@end

@implementation PrintViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    data =[[NSMutableArray alloc]init];
    
    noPalets = [self integerFromString:_lote.totalPalets ];
    nopaquetes = [self integerFromString:_lote.noPaquetesPorPalet ];
    
    
    [self.coillectionView setDelegate:self];
    [self.coillectionView setDataSource:self];
    [_coillectionView registerNib:[UINib nibWithNibName:@"QRCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];

}

-(NSInteger)integerFromString:(NSString *)string
{
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numberObj = [formatter numberFromString:string];
    return [numberObj integerValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QRCollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.noParte.text =_lote.noParte;
    cell.noLote.text =_lote.noLote;
    cell.noPalet.text  =[NSString stringWithFormat:@"%ld",(long)indexPath.section +1];
    
    cell.noFactura.text = _lote.noFactura;
    
    //armar arreglo de deatos
    
    NSString * palet =[NSString stringWithFormat:@"%ld",(long)indexPath.section +1];
    NSString * paquete =[NSString stringWithFormat:@"%ld",(long)indexPath.row +1];
    
    NSString * QRFormat =[NSString stringWithFormat:@"FM-%@-%@-%@-%@-%ld-%ld-%@-%@-%@-%@",_lote.noParte,_lote.noLote,palet,paquete,(long)noPalets,(long)nopaquetes,_lote.cantidadTotalporLote,_lote.unidadMedida,_lote.fechaLlegada,_lote.noFactura];
    cell.imageViewQR.image =[[[QRCodeGenerator alloc] initWithString:QRFormat] getImage];
    
    [data addObject:QRFormat];
    
    
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return nopaquetes;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return noPalets;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(300, 300);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0., 30.);
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableview = nil;
//
//    if (kind == UICollectionElementKindSectionHeader) {
//        HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerid" forIndexPath:indexPath];
//            [headerView.title setText:[NSString stringWithFormat:@"Lote : %ld",(long)indexPath.row]];
//        reusableview = headerView;
//    }
//
//    if (kind == UICollectionElementKindSectionFooter) {
//        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
//
//        reusableview = footerview;
//    }
//
//    return reusableview;
//}



@end
