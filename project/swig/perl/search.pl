#!/usr/bin/env perl

use lib "blib/lib", "blib/arch";
use strict;
use librets;

my $rets = new librets::RetsSession(
    "http://demo.crt.realtors.org:6103/rets/login");

if (!$rets->Login("Joe", "Schmoe"))
{
    print "Invalid login\n";
    exit 1;
}

print "Action: " . $rets->GetAction() . "\n";

my $request = $rets->CreateSearchRequest("Property", "ResidentialProperty",
					 "(ListPrice=300000-)");
$request->SetSelect("ListingID,ListPrice,Beds,City");
$request->SetLimit($librets::SearchRequest::LIMIT_DEFAULT);
$request->SetOffset($librets::SearchRequest::OFFSET_NONE);
$request->SetCountType($librets::SearchRequest::RECORD_COUNT_AND_RESULTS);
my $results = $rets->Search($request);

print "Record count: " . $results->GetCount() . "\n\n";
my $columns = $results->GetColumns();
while ($results->HasNext())
{
    foreach my $column (@$columns)
    {
	    print $column . ": " . $results->GetString($column) . "\n";
    }
    print "\n";
}

my $logout =  $rets->Logout();
print "Billing info: " . $logout->GetBillingInfo() . "\n";
print "Logout message: " . $logout->GetLogoutMessage() . "\n";
print "Connect time: " . $logout->GetConnectTime() . "\n";
