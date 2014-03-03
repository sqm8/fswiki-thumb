package plugin::thumb::ThumbHandler;
# 

# $Id: ThumbHandler.pm,v 1.1.1.1 2007/05/17 05:48:31 sakuma Exp $
#
# Copyright 2005-2007 BitCoffee, Inc. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# * Neither the name of the nor the names of its contributors may be used to
#   endorse or promote products derived from this software without specific
#   prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

use strict;
use lib "./lib";

# /**
#  * Constructor
#  * @author Hiroaki Sakuma <sakuma@bitcoffee.com>
#  * @return $self
#  */

sub new {

	my $class = shift;
	my $self = {};

	eval("use GD");

	if ($@) {
		$self->{use_gd} = 0;
	} else {
		$self->{use_gd} = 1;
	}

	return bless $self, $class;

}


# /*
#  * do_action
#  * @author Hiroaki Sakuma <sakuma@bitcoffee.com>
#  * @author Hiroaki Sakuma <sakuma@bitcoffee.com>
#  *         Original from plugin/attach/AttachHandler.pm
#  *         by Naoki Takezoe <takezoe@aa.bb-east.ne.jp>
#  * @param $wiki
#  * @return $str
#  */

sub do_action {

	my $self = shift;
	my $wiki = shift;
	my $cgi = $wiki->get_CGI();
	my $pagename = $cgi->param("page");
	if($pagename eq ""){
		$pagename = $wiki->config("frontpage");
	}
	my $width = $cgi->param("width");

	my $file = $cgi->param("file");
	if ($file eq "") {
		return $wiki->error("ファイルが指定されていません。");
	}

	if (!$wiki->page_exists($pagename)) {
		return $wiki->error("ページが存在しません。");
	}

	if (!$wiki->can_show($pagename)) {
		return $wiki->error("ページの参照権限がありません。");
	}

	my $filepath = $wiki->config('attach_dir') . "/" . &Util::url_encode($pagename) . "." . &Util::url_encode($file);

	if(!-e $filepath){
		return $wiki->error("ファイルがみつかりません。");
	}

	my $contenttype = &get_mime_type($wiki, $file);
	my $ua = $ENV{"HTTP_USER_AGENT"};
	my $disposition = ($contenttype =~ /^image\// && $ua !~ /MSIE/ ? "inline" : "attachment");

	if ($width ne "" && $self->{use_gd}) {

		my $srcfilepath = $filepath;
		$filepath =~ s/(%2E[^%]+)$/"%28" . $width . "px%29" . $1/e;

		if (!-e $filepath) {

			my $srcimage = GD::Image->new($srcfilepath);
			my $image = GD::Image->new($width, ($srcimage->height() * $width / $srcimage->width()));

			$image->copyResampled($srcimage, 0, 0, 0, 0, $width, ($srcimage->height() * $width / $srcimage->width()), $srcimage->width(), $srcimage->height());

			open(DATA, ">" . $filepath) or die $!;
			binmode(DATA);
			print DATA $image->jpeg(80);
			close(DATA);

		}

	}

	open(DATA, $filepath) or die $!;
	print "Content-Type: $contenttype\n";
#	print &Util::make_content_disposition($file, $disposition);
	print "Content-Disposition: $disposition;filename=\"" . &Jcode::convert($file, 'sjis') . "\"\n\n";
	binmode(DATA);
	while(read(DATA,$_,16384)){ print $_; }
	close(DATA);

	# ログの記録
	&write_log($wiki,"DOWNLOAD",$pagename,$file);
	&count_up($wiki,$pagename,$file);
	
	exit();

}



# /*
#  * get_mime_type
#  * @author Hiroaki Sakuma <sakuma@bitcoffee.com>
#  *         Original from plugin/attach/AttachHandler.pm
#  *         by Naoki Takezoe <takezoe@aa.bb-east.ne.jp>
#  * @param $wiki
#  * @param $file
#  * @return $ctype
#  */
sub get_mime_type {

	my $wiki = shift;
	my $file = shift;
	my $type = lc(substr($file, rindex($file,".") + 1));

	my $hash  = &Util::load_config_hash($wiki,$wiki->config('mime_file'));
	my $ctype = $hash->{$type};

	if($ctype eq "" ){
		$ctype = "application/octet-stream";
	}

	return $ctype;

}


1;
