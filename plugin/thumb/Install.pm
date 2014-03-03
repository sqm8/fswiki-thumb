package plugin::thumb::Install;
# 画像のサムネイルを表示するプラグインを提供します。

# $Id: Install.pm,v 1.1.1.1 2007/05/17 05:48:31 sakuma Exp $
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


# /*
#  * install
#  * @author Hiroaki Sakuma <sakuma@bitcoffee.com>
#  * @param $wiki
#  * @param $cgi
#  * @return $str
#  */

sub install {

	my $wiki = shift;

	$wiki->add_hook("initialize", "plugin::thumb::Initialize");

	$wiki->add_handler("THUMB", "plugin::thumb::ThumbHandler");
	$wiki->add_handler("FILE", "plugin::thumb::FileHandler");

	$wiki->add_inline_plugin("thumb_image", "plugin::thumb::ThumbImage", "HTML");


}


1;
