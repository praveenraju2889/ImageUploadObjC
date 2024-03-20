//
//  ViewController.m
//  ImageUploadObjC
//
//  Created by Praveen Raju on 13/03/24.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
//#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import "Photos/Photos.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)selectDocument:(id)sender {
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.content"] inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
    
    
    
    
   
}
- (IBAction)selectImage:(id)sender {
   // UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.content"] inMode:UIDocumentPickerModeImport];
//    NSArray<UTType*> * contentTypes = @[@"public.content"] ;
//    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initForOpeningContentTypes:contentTypes asCopy:true];
//    documentPicker.delegate = self;
//    [self presentViewController:documentPicker animated:YES completion:nil];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    //imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    
   
}

-(IBAction)selectContact:(id)sender{
    CNContactPickerViewController *peoplePicker = [[CNContactPickerViewController alloc] init];
        peoplePicker.delegate = self;
        NSArray *arrKeys = @[CNContactPhoneNumbersKey]; //display only phone numbers
        peoplePicker.displayedPropertyKeys = arrKeys;
        [self presentViewController:peoplePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    //NSLog(@"Selected Document info: %@", info);
    //NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

        NSData *imgData = UIImageJPEGRepresentation(image, 1.0);

        //NSString *imageString = [[NSString alloc] initWithBytes: [imgData bytes] length:[imgData length] encoding:NSUTF8StringEncoding];

    NSString *base64String = [UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 1.0) base64EncodedStringWithOptions:0];
        
    NSLog(@"Image Data: %@", base64String);

    NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imagePath] options:nil];
    NSString *filename = [[result firstObject] filename];
    NSLog(@"[filename ] %@", filename );
    [self dismissViewControllerAnimated:true completion:nil];
    
}


-(void)provideImageData:(void *)data bytesPerRow:(size_t)rowbytes origin:(size_t)x :(size_t)y size:(size_t)width :(size_t)height userInfo:(id)info{
    NSLog(@"Selected data info: %@", data);
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:true completion:nil];
    
}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{

    CNPhoneNumber *phoneNumber = contactProperty.value;
    NSString *phoneStr = phoneNumber.stringValue;
    NSLog(@"Selected Document URL: %@", phoneStr);
}

-(void)contactPickerDidCancel:(CNContactPickerViewController *)picker{}
-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    NSLog(@"Selected contact : %@", contact.phoneNumbers);
}
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    // Handle the selected document URL
    NSLog(@"Selected Document URL: %@", url);
    NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
        if (error) {
            NSLog(@"Error reading document: %@", error);
            return;
        }
        
        NSString *base64String = [data base64EncodedStringWithOptions:0];
        
        // Now you have the Base64 encoded string of the document
        NSLog(@"Base64 Encoded Document: %@", base64String);
    // Get the filename from the document URL
        NSString *filename = [url lastPathComponent];
        
        // Now you have the filename of the selected document
        NSLog(@"Selected Document Filename: %@", filename);
    // Perform actions with the selected document URL
}


- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    // Handle cancellation (optional)
    NSLog(@"Document picker was cancelled.");
}

@end
