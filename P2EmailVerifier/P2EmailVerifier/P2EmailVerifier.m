//
//  P2EmailVerifier.m
//  P2EmailVerifier
//
//  Created by Pedro Plowman on 15/07/13.
//  Copyright (c) 2013 Pedro Plowman
//
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "P2EmailVerifier.h"

#define url_base @"http://api.verify-email.org/api.php?"
#define username @"your_verify-email.org_username_here"
#define password @"your_verify-email.org_password_here"

@implementation P2EmailVerifier

- (instancetype)initWithDelegate:(id<P2EmailVerifierDelegate>)delegate
{
	if (![self init]) return nil;
	_verifierDelegate = delegate;
	return self;
}

+ (BOOL)validatePatternForEmailAddress:(NSString*)emailAddress
{
	NSString *emailRegEx =
	@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
	@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
	@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
	@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
	@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
	@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
	@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegEx];
	
	return [emailTest evaluateWithObject:emailAddress];
}

- (void)verifyEmailAddress:(NSString*)emailAddress
{
	// API URL...
	// http://api.verify-email.org/api.php?usr=your_username&pwd=your_password&check=email@tocheck.com
	
	if (![P2EmailVerifier validatePatternForEmailAddress:emailAddress]) {
		[_verifierDelegate emailVerificationResult:P2InvalidPattern];
		return;
	}
	
	NSURL* verifyURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@usr=%@&pwd=%@&check=%@", url_base, username, password, emailAddress]];
	NSURLRequest* urlRequest = [NSURLRequest requestWithURL:verifyURL];
	
	[NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
		if (error) {
			[_verifierDelegate emailVerificationResult:P2NSURLRequestError];
			return;
		}
		
		NSDictionary* verifyResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
		
		NSLog(@"verifyResult: %@", [verifyResult description]);
		
		BOOL verify_status = [[verifyResult objectForKey:@"verify_status"] boolValue];
		if (verify_status) {
			[_verifierDelegate emailVerificationResult:P2ValidEmail];		//	It's all good to go :-)
			return;
		}
		
		NSString* verify_status_desc = [verifyResult objectForKey:@"verify_status_desc"];
		NSString* checkString;
		
		checkString = [NSString stringWithFormat:@"MX record about '%@' does not exist.", [[emailAddress componentsSeparatedByString:@"@"] objectAtIndex:1]];
		if ([verify_status_desc rangeOfString:checkString].location != NSNotFound) {
			[_verifierDelegate emailVerificationResult:P2BadDomainName];	//	There's a problem with the domain name.
			return;
		}
		
		checkString = @"The email account that you tried to reach does not exist.";
		if ([verify_status_desc rangeOfString:checkString].location != NSNotFound) {
			[_verifierDelegate emailVerificationResult:P2BadUserName];		//	There's a problem with the email user name.
			return;
		}
		
		[_verifierDelegate emailVerificationResult:P2UnknownEmailError];	//	There's a problem but P2EmailVerifier can't tell what it is.
	}];
}

@end
