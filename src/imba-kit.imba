require 'imba/src/imba/imba'
require 'imba/src/imba/tag'

extern Imba$log
extern Imba$findClass
extern Imba$setRoot

export var log = Imba$log
export var findClass = Imba$findClass


console =
	log: log


var bootFn

global def Imba$boot
	# TODO: Error handling
	bootFn().dom

export def onBoot &blk
	bootFn = blk


tag view < element
	def self.useNodeClass name
		@nodeClass = findClass(name)

	useNodeClass 'ImbaNode'

	def self.createNode
		@nodeClass.create

	prop parent
	prop isDirty

	def dom=(node)
		@isDirty = yes
		@_childrenVersion = 0
		@dom = node

	def markDirty
		if !@isDirty
			dom.markDirty
			@isDirty = true
		self

	def setParent view
		if @parent !== view
			@parent = view
			dom.setParent(view.dom)
		@_parentVersion = view.@_childrenVersion
		self

	def _verifyParent oldParent
		if !@parent
			return

		if @parent === oldParent
			if @_parentVersion == oldParent.@_childrenVersion
				return

		dom.setParent(null)
		@parent = null
		@_parentVersion = null
		self

	def setText text
		setChildren text

	def setChildren children
		if children isa String
			throw Error.new("Text is not supported")

		if !(children isa Array)
			children = [children]

		# We've got new children to render. Bump the version.
		@_childrenVersion++

		var doms = []

		for child, idx in children
			if @children and @children[idx] !== child
				# The structure has changed. Mark as dirty.
				markDirty

			child.parent = self

			if child.isDirty
				# The child has changed. Mark as dirty.
				markDirty

			doms.push(child.dom)

		for oldChild in @children
			oldChild._verifyParent

		@children = children

		dom.setChildren(doms)

		self

	attr padding
	attr flex
	attr height
	attr backgroundColor

	def setAttribute key, value
		let setter = "set{key[0].toUpperCase}{key.substring(1)}"
		dom[setter](value)
		markDirty
		self

	attr width
	attr height
	attr maxHeight
	attr maxWidth

	attr left
	attr right
	attr top
	attr bottom


