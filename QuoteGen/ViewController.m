#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize myQuotes;
@synthesize movieQuotes;
@synthesize quote_text;
@synthesize quote_opt;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myQuotes = [NSArray arrayWithObjects:
                     @"Live and let live",
                     @"Don't cry over spilt milk",
                     @"Always look on the bright side of life",
                     @"Nobody's perfect",
                     @"Can't see the woods for the trees",
                     @"Better to have loved and lost than not loved at all",
                     @"The early bird catches the worm",
                     @"As slow as a wet week",
                     nil];
    
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"quotes" ofType:@"plist"];
    self.movieQuotes= [[NSMutableArray arrayWithContentsOfFile:plistCatPath] copy];
}

- (void)viewDidUnload
{
    self.myQuotes = nil;
    self.movieQuotes = nil;
    self.quote_text = nil;
    self.quote_opt = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)quote_btn_touch:(id)sender {
    // 1 - Display all personal quotes
    if (self.quote_opt.selectedSegmentIndex == 2) {
        // 1.1 - Get array count
        int array_tot = [self.myQuotes count];
        // 1.2 - Initialize string for concatenated quotes
        NSString *all_my_quotes = @"";
        // 1.3 - Iterate through array
        for (int x=0; x < array_tot; x++) {
            NSString *my_quote = [self.myQuotes objectAtIndex:x];
            all_my_quotes = [NSString stringWithFormat:@"%@\n%@\n",  all_my_quotes,my_quote];
        }
        self.quote_text.text = [NSString stringWithFormat:@"%@", all_my_quotes];
    }
    // 2 - Get movie quotes
    else {
        // 2.1 - determine category
        NSString *selectedCategory = @"classic";
        if (self.quote_opt.selectedSegmentIndex == 1) {
            selectedCategory = @"modern";
        }
        // 2.2 - filter array by category using predicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", selectedCategory];
        NSArray *filteredArray = [self.movieQuotes filteredArrayUsingPredicate:predicate];
        // 2.3 - get total number in filtered array
        int array_tot = [filteredArray count];
        // 2.4 - as a safeguard only get quote when the array has rows in it
        if (array_tot > 0) {
            // 2.5 - get random index
            int index = (arc4random() % array_tot);
            // 2.6 - get the quote string for the index
            NSString *quote = [[filteredArray objectAtIndex:index] valueForKey:@"quote"];
            self.quote_text.text = [NSString stringWithFormat:@"Movie Quote:\n\n%@",  quote];
            // 2.7 - Check if there is a source
            NSString *source = [[filteredArray objectAtIndex:index] valueForKey:@"source"];
            if (![source length] == 0) {
                quote = [NSString stringWithFormat:@"%@\n\n(%@)",  quote, source];
            }
            // 2.8 - Customize quote based on category
            if ([selectedCategory isEqualToString:@"classic"]) {
                quote = [NSString stringWithFormat:@"From Classic Movie\n\n%@",  quote];
            } else {
                quote = [NSString stringWithFormat:@"Movie Quote:\n\n%@",  quote];
            }
            // 2.9 - Display quote
            if ([source hasPrefix:@"Harry"]) {
                quote = [NSString stringWithFormat:@"HARRY ROCKS!!\n\n%@",  quote];
            }
            // 2.10 - Update row to indicate that it has been displayed
            int movie_array_tot = [self.movieQuotes count];
            NSString *quote1 = [[filteredArray objectAtIndex:index] valueForKey:@"quote"];
            for (int x=0; x < movie_array_tot; x++) {
                NSString *quote2 = [[movieQuotes objectAtIndex:x] valueForKey:@"quote"];
                if ([quote1 isEqualToString:quote2]) {
                    NSMutableDictionary *itemAtIndex = (NSMutableDictionary *)[movieQuotes objectAtIndex:x];
                    [itemAtIndex setValue:@"DONE" forKey:@"source"];
                }
            }
            self.quote_text.text = quote;
        } else {
            self.quote_text.text = [NSString stringWithFormat:@"No quotes to display."];
        }
    }
}


@end
