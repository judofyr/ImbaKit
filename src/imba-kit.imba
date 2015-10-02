require 'imba/src/imba/imba'
require 'imba/src/imba/tag'

var log = Imba$log

# Magic constants from css-layout
FlexColumn = 0
FlexColumnReverse = 1
FlexRow = 2
FlexRowReverse = 3

FlexStart = 1
FlexCenter = 2
FlexEnd = 3

FlexSpaceBetween = 4
FlexSpaceAround = 5

FlexStretch = 4

FlexRelative = 0
FlexAbsolute = 1

FlexNoWrap = 0
FlexWrap = 1

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
