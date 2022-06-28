//
//  ServerBridge.h
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

#ifndef ServerBridge_h
#define ServerBridge_h

@interface ServerBridge: NSObject{

}
- (void) setDirectoryPath:(NSString*)input;
- (void) setServerBaseURL:(NSString*)input;

- (void) startServer;
- (void) stopServer;
- (BOOL) serverIsRunning;

@end

#endif /* ServerBridge_h */
