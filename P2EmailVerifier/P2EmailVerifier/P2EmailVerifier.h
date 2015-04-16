//
//  P2EmailVerifier.h
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

@protocol P2EmailVerifierDelegate;

typedef enum {
	P2ValidEmail,			//	It's all good to go :-)
	P2InvalidPattern,		//	The address doesn't fit a valid email address pattern.
	P2BadDomainName,		//	There's a problem with the domain name.
	P2BadUserName,			//	There's a problem with the email user name.
	P2UnknownEmailError,	//	There's a problem but P2EmailVerifier can't tell what it is.
	P2NSURLRequestError		//	NSURLRequest returned an error.
} P2EmailVerificationResult;

@interface P2EmailVerifier : NSObject

@property (assign, nonatomic) id<P2EmailVerifierDelegate> verifierDelegate;

- (instancetype)initWithDelegate:(id<P2EmailVerifierDelegate>)delegate;
+ (BOOL)validatePatternForEmailAddress:(NSString*)emailAddress;
- (void)verifyEmailAddress:(NSString*)emailAddress;

@end

@protocol P2EmailVerifierDelegate <NSObject>

- (void)emailVerificationResult:(P2EmailVerificationResult)result;

@end
