my $dir = '/users/vegorant/public_html/gitlab_api';
opendir(DIR, $dir) or die $!;
my $fix_proj = 0;
foreach my $parent_dir (readdir(DIR))
{
    chomp $parent_dir;
    if ($parent_dir eq '.' || $parent_dir eq '..')
    {
        #ignore
    }
    elsif (-d $parent_dir)
    {
        opendir(PROJECT, $parent_dir) or die $!;
        foreach my $project_dir(readdir(PROJECT))
        {
            chomp $project_dir;
            my $path = (join ('/', $dir, $parent_dir, $project_dir));
            if (-d $path && $project_dir eq 'builds')
            {
                $fix_proj++;
                my @out = `cd $path;git remote -v`;
                my ($source, $git_repo, $action) =  ($out[1] =~ /(\S+)\s+(\S+)\s+(\S+)/);
                #if ($git_repo =~ /eman_cpan_modules/)
                if ($git_repo =~ /deployment/ && $git_repo !~ /eman_cpan_modules/)
                {
                    #printf "%d. %s : %s\n", $fix_proj, $parent_dir, $git_repo;
                    #my $sub_dir = join "/", $path, 'eman_cpan_modules';
                    my $sub_dir = join "/", $path, 'deployment';
                    opendir(SUB_DIR, $sub_dir) or die $!;
                    foreach my $sub (readdir(SUB_DIR))
                    {
                        chomp $sub;
                        if ($sub eq '.' || $sub eq '..')
                        {
                            #ignore
                        }
                        else
                        {
                            print ($parent_dir , " : " , $sub, "\n");
                            if ($parent_dir eq $sub)
                            {
                                if (open (FH, ">./${sub}.sh") or die $!)
                                {
                                    print FH qq!cd $dir/$parent_dir\n!;
                                    #print FH qq!cp -rfv builds/eman_cpan_modules/$sub/* .\n!;
                                    print FH qq!cp -rfv builds/deployment/$sub/* .\n!;
                                    print FH qq!git add .\n!;
                                    print FH qq!git status\n!;
                                    print FH qq!git commit -m "Moved tree up"\n!;
                                    #print FH qq!git rm -rf builds/eman_cpan_modules/$sub\n!;
                                    print FH qq!git rm -rf builds/deployment/$sub\n!;
                                    print FH qq!git commit -m"Moved files to top level directory"\n!;
                                    print FH qq!git push\n!;
                                    close FH;
                                }
                            }
                        }
                    }
                }
            }
        }
        closedir(PROJECT);
    }
}
closedir(DIR);
