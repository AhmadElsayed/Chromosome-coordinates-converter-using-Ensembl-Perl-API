use strict;
use warnings;

use IO::File;
use Getopt::Long;

use Bio::EnsEMBL::Registry;

my $registry = 'Bio::EnsEMBL::Registry';

use Scalar::Util qw(looks_like_number);
my $host = 'ensembldb.ensembl.org';
my $port = 3306;
my $user = 'anonymous';

$registry->load_registry_from_db( '-host' => $host,
                                  '-port' => $port,
                                  '-user' => $user );

my $repeat = 1;

# Start the while loop to process multiple inputs based on user's request
# After showing the result, the user will be asked whether he wants to enter another input
# When $repear = 0, the program will exit
while ($repeat == 1)
{
  my $species = "-";
  my $start = -1;
  my $end = -1;
  my $version = "-";
  my $strand = -999;

  ########### start
  # Get the species from the user
  while($species eq "-")
  {
    print "Enter the species (ex: human) \n";
    $species = <STDIN>;
    chomp($species);
    if($species eq "") { 
      $species = "-";
    }
    else {
      printf ("%s: %s\n", "Selected Species: ",  $species); 
    }
  }
  ########### end
  
  ########### start
  # Get the assembly version that will be converted to GRCh37
  while($version eq "-")
  {
    print "\nEnter the chromosome assembly version (ex: GRCh38) \n";
    $version = <STDIN>;
    chomp($version);
    if($version eq "") {
      printf ("%s\n", "Wrong input, Please try again");
      $version = "-";
    }
    else {
      printf ("%s: %s\n", "Selected version",  $version); 
    }
  }
  ########### end
  
  ########### start
  # Get the starting coordinate
  while ($start == -1)
  {
    # testing input 1039265
    print "\nEnter the chromosome coordinates start point (ex: 1039265) \n";
    my $start_ = <STDIN>;
  
    if(looks_like_number($start_))
    {
      $start = $start_;
      printf ("%s: %s\n", "Selected start point",  $start); 
    }
    else{
      printf ("%s\n", "Wrong input, Please try again");
    }
  }
  ########### end

  ########### start
  # Get the ending coordinate
  while ($end == -1)
  {
    # testing input 1039365
    print "\nEnter the chromosome coordinates end point (ex: 1039365) \n";
    my $end_ = <STDIN>;
    
    if(looks_like_number($end))
    {
      $end = $end_;
      printf ("%s: %s\n", "Selected end point",  $end); 
    }
    else{
      printf ("%s\n", "Wrong input, Please try again");
    }
  }
  ########### end

  ########### start
  # Get the input strand
  while ($strand == -999)
  {
    # testing input 1039365
    print "\nEnter the strand (ex: 1) \n";
    my $strand_ = <STDIN>;
    
    if(looks_like_number($strand_))
    {
      $strand = $strand_;  
      printf ("%s: %s\n", "Selected strand",  $strand); 
    }
    else{
      printf ("%s\n", "Wrong input, Please try again");
    }
  }
  ########### end

  ########### start
  # Obtain an Object adaptor from the Registry
  my $slice_adaptor = $registry-> get_adaptor( $species, 'Core', 'Slice' );
  ########### end
  
  ########### start
  # Obtain a slice covering the region from $start to $end (inclusively) of defined chromosome
  my $old_slice =  $slice_adaptor->fetch_by_region("chromosome", "X", $start, $end, $strand, $version);
  ########### end
  
  ########### start
  # Obtain coordinates in GRCh37 using the old version's slice 
  foreach my $segment ( @{ $old_slice->project('chromosome', 'GRCh37') } ) {
    my $new = $segment->to_Slice();
    printf("\n%s ",$segment->to_Slice()->name());  
  }
  ########### end

  ########### start
  # Asking the user whether he wants to try other inputs
  print "\nDo you want to continue (Y / N)";
  my $IsContinue = <STDIN>;
  chomp($IsContinue);
  $repeat = $IsContinue eq 'Y' ? 1 : 0;
  ############ end
}
print("\n");
