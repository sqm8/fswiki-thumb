fswiki-thumb
============

thumb plugin for FreeStyle Wiki

!!!サムネイルプラグイン

README

 Hiroaki Sakuma <sakuma@bitcoffee.com>
 Copyright 2005-2007 BitCoffee, Inc. All Rights Reserved.



!!サムネイルプラグインとは

解像度の大きな画像を添付する際，小さな画像 (サムネイル) を自動的に生成し，表示するプラグインです．



!!使い方

インストールするだけです．

サムネイルを貼りたい場所で，

 {{thumb_image ImageFile.jpg}}

といった記述を行うと，サムネイルが表示されます．詳しい使い方は，プラグインのヘルプを参照してください．



!!注意

サムネイルを生成すると，'''画像名(リサイズした横幅).拡張子'''という添付ファイルを自動で作成します．自動で削除は行わないので，様々な解像度のサムネイルが作られると，ディスク容量を消費します．

要らないファイルは，定期的に削除するようにお願いします．



!!必要なソフトウェア


Perl module の，GD がインストールされていれば，画像サイズはサーバサイドで調整されます．

""# cpan install GD

また，Image::ExifTool がインストールされていれば，画像情報が得られます．

""# cpan install Image::ExifTool


これらは無くても動作するようになっていますが，可能であればインストールを行ってください．(インストールされていない場合，機能が制限されます)



