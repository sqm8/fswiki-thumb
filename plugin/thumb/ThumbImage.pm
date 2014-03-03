package plugin::thumb::ThumbImage;
# <p>添付した画像ファイルのサムネイル画像を表示します。</p>
# <pre>
# {{thumb_image ファイル名}}
# </pre>
# <p>別のページに添付されたファイルを参照することもできます。</p>
# <pre>
# {{thum_image ファイル名,ページ名}}
# </pre>
# <p>画像に説明文を付ける事ができます。</p>
# <pre>
# {{thum_image ファイル名,ページ名,説明文}}
# </pre>
# <p>サムネイル画像のサイズを指定することもできます。横幅のピクセル数を指定します。</p>
# <pre>
# {{thum_image ファイル名,ページ名,250px}}
# </pre>
# <p>サムネイル画像の配置を指定することもできます。(left，right，none)</p>
# <pre>
# {{thum_image ファイル名,ページ名,right}}
# </pre>
# <p>複数のオプションを同時に指定することもできます。(ファイル名、ページ名以外の順序は自由です)</p>
# <pre>
# {{thum_image ファイル名,ページ名,説明文,250px,right}}
# </pre>

#
# Copyright 2005-2009 BitCoffee, Inc. All rights reserved.
# Copyright (C) medicalsystems, Inc.
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
#  * @author Hiro Sakuma <sakuma@zero52.com>
#  * @return $self
#  */

sub new {

	my $class = shift;
	my $self = {};

	return bless $self, $class;

}


# /*
#  * inline
#  * @author Hiro Sakuma <sakuma@zero52.com>
#  * @param $wiki
#  * @param $opt
#  * @return $str
#  */

sub inline {

	my $self = shift;
	my $wiki = shift;
	my $file = shift;
	my $page = shift;
	my @opt = @_;
	#my $cgi = $wiki->get_CGI();
	my $align = 'right';
	my $width = '250';
	my $caption = '';
	my ($login, $return);

	if($file eq ""){
		return &Util::paragraph_error("ファイルが指定されていません。","HTML");
	}

	if($page eq ""){
		$page = $wiki->get_CGI()->param("page");
	}

	if(!$wiki->can_show($page)){
		return &Util::paragraph_error("ページの参照権限がありません。","HTML");
	}

	my $filename = $wiki->config('attach_dir')."/".&Util::url_encode($page).".".&Util::url_encode($file);
	if(!-e $filename){
		return &Util::paragraph_error("ファイルが存在しません。","HTML");
	}


	foreach (@opt) {

		if ($_ eq 'left'|| $_ eq 'right' || $_ eq 'center'  || $_ eq 'none') {
			$align = $_;
		} elsif ($_ =~ m/^([0-9]+)px$/) {
			$width = $1;
		} else {
			$caption .= $_;
		}

	}


	if ($align eq 'left' || $align eq 'right') {
		$return .= "<div class=\"thumbinner\" style=\"display: block; padding: 1px; width: " . ($width + 2) . "px; float: " . $align . "; clear: " . $align . "; \">";
	} else {
		$return .= "<div class=\"thumbinner\" style=\"display: block; padding: 1px; width: " . ($width + 2) . "px; \">";
	}

	$return .= "<a href=\"" . $wiki->config('script_name') . "?action=FILE&amp;page=" . &Util::url_encode($page) . "&amp;file=" . &Util::url_encode($file) . "\"><img src=\"" . $wiki->config('script_name') . "?action=THUMB&amp;page=" . &Util::url_encode($page) . "&amp;file=" . &Util::url_encode($file) . "&amp;width=" . &Util::url_encode($width) . "\" width=\"" . $width . "\" alt=\"" . $caption . "\" /></a><div class=\"thumbcaption\">" . $caption . "</div></div>\n";


	return $return;

}



1;
