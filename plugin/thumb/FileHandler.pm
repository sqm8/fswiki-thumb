package plugin::thumb::FileHandler;
#

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

	eval("use Image::ExifTool");

	if ($@) {
		$self->{use_exiftool} = 0;
	} else {
		$self->{use_exiftool} = 1;
	}

	return bless $self, $class;

}


# /*
#  * do_action
#  * @author Hiro Sakuma <sakuma@zero52.com>
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
	my ($return);
	my $tags = {
		'Model' => 'モデル名',
		'Make' => 'メーカ',
		'Quality' => 'クオリティ',
		'ShutterSpeed' => 'シャッター速度',
		'DateTimeOriginal' => '撮影日時',
	};

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


	$wiki->set_title($file);


	if ($self->{use_exiftool}) {

		my $exiftool = Image::ExifTool->new();

		my $info = $exiftool->ImageInfo($filepath);

		my $width = 640;
		my $height;
		if ($info->{ImageWidth} > $width) {
			$height = $info->{ImageHeight} * 640 / $info->{ImageWidth};
			$return .= "<a href=\"" . $wiki->config('script_name') . "?action=THUMB&amp;page=" . &Util::url_encode($pagename) . "&amp;file=" . &Util::url_encode($file) . "\"><img src=\"" . $wiki->config('script_name') . "?action=THUMB&amp;page=" . &Util::url_encode($pagename) . "&amp;file=" . &Util::url_encode($file) . "&amp;width=" . &Util::url_encode($width) . "\" width=\"" . $width . "\" alt=\"\" /></a>\n";
		} else {
			$width = $info->{ImageWidth};
			$height = $info->{ImageHeight};
			$return .= "<a href=\"" . $wiki->config('script_name') . "?action=THUMB&amp;page=" . &Util::url_encode($pagename) . "&amp;file=" . &Util::url_encode($file) . "\"><img src=\"" . $wiki->config('script_name') . "?action=THUMB&amp;page=" . &Util::url_encode($pagename) . "&amp;file=" . &Util::url_encode($file) . "\" width=\"" . $width . "\" alt=\"\" /></a>\n";
		}

		$return .= "<p>このプレビューのサイズ: " . $width . " x " . $height . " px</p>";
		$return .= "<p><a href=\"" . $wiki->config('script_name') . "?action=THUMB&amp;page=" . &Util::url_encode($pagename) . "&amp;file=" . &Util::url_encode($file) . "\">高解像度での画像</a> (" . $info->{ImageWidth} . " x " . $info->{ImageHeight} . " px, ファイルサイズ: " . $info->{FileSize} . ", MIMEタイプ: " . $info->{MIMEType} . ")\n";


		$return .= "<h3>画像情報</h3>";
		$return .= "<table>\n";

		foreach (sort keys %$info) {
			if (exists $tags->{$_}) {
				$return .= "<tr><th>" . $tags->{$_} . "</th><td>" . $info->{$_} . "</td></tr>\n";
			}
		}

		$return .= "</table>\n";

	} else {

		my $width = 640;
		$return .= "<a href=\"" . $wiki->config('script_name') . "?action=THUMB&amp;page=" . &Util::url_encode($pagename) . "&amp;file=" . &Util::url_encode($file) . "\"><img src=\"" . $wiki->config('script_name') . "?action=THUMB&amp;page=" . &Util::url_encode($pagename) . "&amp;file=" . &Util::url_encode($file) . "&amp;width=" . &Util::url_encode($width) . "\" width=\"" . $width . "\" alt=\"\" /></a>\n";

		$return .= "<p><a href=\"" . $wiki->config('script_name') . "?action=THUMB&amp;page=" . &Util::url_encode($pagename) . "&amp;file=" . &Util::url_encode($file) . "\">高解像度での画像</a>\n";


	}


	return $return;

}



1;
