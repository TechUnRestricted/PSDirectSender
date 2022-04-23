//
//  ServerLinker.h
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

#ifndef ServerLinker_h
#define ServerLinker_h

@interface MyClass : NSObject{

}
- (void) setDirectoryPath:(NSString*)input;
- (void) setServerBaseURL:(NSString*)input;

- (void) startServer;
- (void) stopServer;
- (BOOL) serverIsRunning;

@end

#endif /* ServerLinker_h */
