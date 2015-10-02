require 'imba/src/imba/imba'
require 'imba/src/imba/tag'

var log = Imba$log

console =
	log: log

var bootFn

global def Imba$boot
	# TODO: Error handling
	bootFn().dom

export def onBoot &blk
	bootFn = blk

import './imba-kit/view'
import './imba-kit/text'
