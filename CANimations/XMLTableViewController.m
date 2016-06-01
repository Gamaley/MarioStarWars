//
//  XMLTableViewController.m
//  CANimations
//
//  Created by Vladyslav Gamalii on 31.05.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

#import "XMLTableViewController.h"
#import "Sample.h"
#import "SampleTableViewCell.h"
#import "SampleViewController.h"

@interface XMLTableViewController () <NSXMLParserDelegate>

@property (strong,nonatomic) NSMutableArray *samplesArray;
@property (strong, nonatomic) NSMutableString *foundString;
@property (strong, nonatomic) NSString *currentString;
@property (strong, nonatomic) Sample *sampleObject;
@property (strong, nonatomic) NSXMLParser *xmlParser;

@end

@implementation XMLTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.samplesArray = [NSMutableArray new];
    [self setup];
}

#pragma mark - Private

- (void)setup
{
    NSString *pathForXML = [[NSBundle mainBundle] pathForResource:@"Sample" ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:pathForXML];
    self.foundString = [[NSMutableString alloc] init];
    self.xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    self.xmlParser.delegate = self;
    [self.xmlParser parse];
}

#pragma mark - <UITableViewDelegate>

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.samplesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SampleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SampleTableViewCell reuseIdentifier] forIndexPath:indexPath];
    
    Sample *sample = [self.samplesArray objectAtIndex:indexPath.row];
    cell.sampleObject = sample;
    cell.name = sample.author;
    cell.title = sample.title;
    
    return cell;
}


#pragma mark - <NSXMLParserDelegate>

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict
{
    if ([elementName isEqualToString:@"book"]) {
        if (self.sampleObject) {
            [self.samplesArray addObject:self.sampleObject];
            self.sampleObject = nil;
        }
        self.sampleObject = [[Sample alloc] init];
        self.sampleObject.identifier = [attributeDict valueForKey:@"id"];
    }
    self.currentString = elementName;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName
{
    if ([elementName isEqualToString:@"author"]) {
        self.sampleObject.author = [[self.foundString copy] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    } else if ([elementName isEqualToString:@"title"]) {
        self.sampleObject.title = [[self.foundString copy] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    } else if ([elementName isEqualToString:@"genre"]) {
        self.sampleObject.genre = [[self.foundString copy] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    } else if ([elementName isEqualToString:@"price"]) {
        self.sampleObject.price = [[[self.foundString copy] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] doubleValue];
    } else if ([elementName isEqualToString:@"publish_date"]) {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.dateFormat = @"yyyy-MM-dd";
        self.sampleObject.publishDate = [[self.foundString copy] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    } else if ([elementName isEqualToString:@"description"]) {
        self.sampleObject.info = [[self.foundString copy] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    [self.foundString setString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([self.currentString isEqualToString:@"author"] || [self.currentString isEqualToString:@"title"] || [self.currentString isEqualToString:@"genre"] || [self.currentString isEqualToString:@"price"] || [self.currentString isEqualToString:@"publish_date"] || [self.currentString isEqualToString:@"description"]) {
        if (![string isEqualToString:@"\n"]) {
            [self.foundString appendString:string];
        }
    }
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.samplesArray = [[NSMutableArray alloc] init];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.tableView reloadData];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"%@",parseError.localizedDescription);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SampleViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.sampleObject = ((SampleTableViewCell *)sender).sampleObject;
}

@end
