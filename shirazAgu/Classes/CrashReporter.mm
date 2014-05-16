#import <Foundation/Foundation.h>
#import "PLCrashReporter.h"
#import "CrashReporter.h"


NSString* GetCrashReportsPath();


static void SavePendingCrashReport()
{
	if (![[UnityPLCrashReporter sharedReporter] hasPendingCrashReport]) 
		return;

	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error;

	if (![fm createDirectoryAtPath:GetCrashReportsPath() withIntermediateDirectories:YES attributes:nil error:&error])
	{
		printf_console("CrashReporter: could not create crash report directory: %s\n", [[error localizedDescription] UTF8String]);
		return;
	}

	NSData *data = [[UnityPLCrashReporter sharedReporter] loadPendingCrashReportDataAndReturnError: &error];
	if (data == nil)
	{
		printf_console("CrashReporter: failed to load crash report data: %s\n", [[error localizedDescription] UTF8String]);
		return;
	}

	NSString* file = [GetCrashReportsPath() stringByAppendingPathComponent: @"crash-"];
	unsigned long long seconds = (unsigned long long)[[NSDate date] timeIntervalSince1970];
	file = [file stringByAppendingString:[NSString stringWithFormat:@"%llu", seconds]];
	file = [file stringByAppendingString:@".plcrash"];
	if ([data writeToFile:file atomically:YES])
	{
		printf_console("CrashReporter: saved pending crash report.");
		if (![[UnityPLCrashReporter sharedReporter] purgePendingCrashReportAndReturnError: &error])
		{
			printf_console("CrashReporter: couldn't remove pending report: %s\n", [[error localizedDescription] UTF8String]);
		}
	}
	else
	{
		printf_console("CrashReporter: couldn't save crash report.");
	}
}


void InitCrashReporter()
{
	NSError *error;

	if (![[UnityPLCrashReporter sharedReporter] enableCrashReporterAndReturnError: &error]) {
		NSLog(@"Could not enable crash reporter: %@", error);
	}

	SavePendingCrashReport();
}


// This function will be called when AppDomain.CurrentDomain.UnhandledException event is triggered.
// When running on device the app will do a hard crash and it will generate a crash log.
void CrashedCheckBellowForHintsWhy()
{
#if ENABLE_CRASH_REPORT_SUBMISSION
	// Wait if app has crashed before we were able to submit an older pending crash report. This
	// could happen if app crashes at startup.
	WaitWhileCrashReportsAreSent();
#endif

#if ENABLE_IOS_CRASH_REPORTING || ENABLE_CUSTOM_CRASH_REPORTER
	// Make app crash hard here
	__builtin_trap();

	// Just in case above doesn't work
	abort();
#endif
}
