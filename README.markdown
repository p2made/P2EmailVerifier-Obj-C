#P2EmailVerifier - Objective C version

A simple Objective C wrapper to the verify-email.org API. 

NOTE: This project won't be updated as I am converting all my Objective C code to Swift code.

##Instalation 

1. Get an account at  <http://verify-email.org>, they start at free.
2. Add the files `P2EmailVerifier.h` & `P2EmailVerifier.m` to your project.
3. In `P2EmailVerifier.m` change the values of the #define constants `username` & `password` to your verify-email.org username & password.
4. Import P2EmailVerifier using `Import "P2EmailVerifier.h"` where you want to use it.
5. Implement the `P2EmailVerifierDelegate` where you're using P2EmailVerifier.

**NOTE:** The verify-email.org API uses your login credentials so take that into consideration when you choose your password (I've sent them a suggestion to adopt OAuth).

##Usage

First set up your verifier. Usually that will look like this...

	P2EmailVerifier* verifier = [[P2EmailVerifier alloc] initWithDelegate:self];

When you want to verify an email address call the verifier like this... 

	[verifier verifyEmailAddress:@"email@to.check"];

The delegate method will recieve a `P2EmailVerificationResult` with 5 possible values...

- `P2ValidEmail`			It's all good to go :-)
- `P2InvalidPattern`		The address doesn't fit a valid email address pattern.
- `P2BadDomainName`			There's a problem with the domain name.
- `P2BadUserName`			There's a problem with the email user name.
- `P2UnknownEmailError`		There's a problem but P2EmailVerifier can't tell what it is.
- `P2NSURLRequestError`		NSURLRequest returned an error.

Handle that result as suits your needs in your app.

##P2?

My initials are PP so think P squared ;)

##Changes

####2012-08-04
* Added pre-check using regex from <http://www.cocoawithlove.com/2009/06/verifying-that-string-is-email-address.html>.

####2012-07-14 - v1.1.0
* Made the verification asynchronous.

####2012-06-26 – v1.0.1
* Removed dependency on JSONKit (suggested by Sadat Rahman).
* Added `isValidEmailAddress` method (suggested by Dave Sag).

####2012-06-24 – v1.0.0
* Initial version

##The MIT License (MIT)

Copyright (c) 2013 Pedro Plowman <pedrofp@me.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.