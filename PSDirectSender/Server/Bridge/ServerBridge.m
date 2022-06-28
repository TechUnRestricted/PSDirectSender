//
//  ServerBridge.m
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

#import <Foundation/Foundation.h>
#include "../Mongoose/mongoose.h"
#import "ServerBridge.h"

//TODO: Split this file into header and implementation

@implementation ServerBridge {
    
}

NSString *directoryPath;
NSString *extraHeaders = @"Server: PSDirectSender/Mongoose\r\n";
NSString *serverBaseURL;

unsigned int pollRate = 1000;
bool serverIsTurnedOn;

static void fn(struct mg_connection *c, int ev, void *ev_data, void *fn_data) {
    struct mg_http_serve_opts opts = {
        .root_dir = [directoryPath UTF8String],
        .extra_headers = [extraHeaders UTF8String]

    };   // Serve local dir
    
    if (ev == MG_EV_HTTP_MSG) mg_http_serve_dir(c, (struct mg_http_message*)ev_data, &opts);
}

- (void) startServer {
    serverIsTurnedOn = true;
    struct mg_mgr mgr;
    mg_mgr_init(&mgr);
    mg_http_listen(&mgr, [serverBaseURL UTF8String], fn, NULL);
    
    while (serverIsTurnedOn){
        mg_mgr_poll(&mgr, pollRate);
    }
    
    mg_mgr_free(&mgr);
}

- (void) stopServer {
    serverIsTurnedOn = false;
}

- (BOOL) serverIsRunning {
    return serverIsTurnedOn;
}

- (void) setDirectoryPath:(NSString*)input {
    directoryPath = input;
}

- (void) setServerBaseURL:(NSString*)input {
    serverBaseURL = input;
}

@end
