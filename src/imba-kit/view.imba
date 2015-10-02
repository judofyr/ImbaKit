var findClass = Imba$findClass

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
		@props = {}
		@dom = node
		self

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
		
		# Do we have any new children?
		var newChildren

		if @children
			newChildren = (@children:length != children:length)
		else
			newChildren = true

		for child, idx in children
			if @children and @children[idx] !== child
				# The structure has changed. Mark as dirty.
				markDirty
				newChildren = true

			child.parent = self

			if child.isDirty
				# The child has changed. Mark as dirty.
				markDirty

			doms.push(child.dom)

		if !newChildren
			return self

		for oldChild in @children
			oldChild._verifyParent

		@children = children

		dom.setChildren(doms)

		self

	def self.defineProps(names, options = {})
		let setters = []
		for name in names
			let setter = defineProp(name, options)
			setters.push(setter)

		if options:combined
			self:prototype["set{options:prefix}"] = do |value|
				for setter in setters
					this[setter](value)
				this.markDirty
				this


	def self.defineProp(name, options = {})
		var prefix = "set"

		if options:prefix
			prefix += options:prefix

		let setter = "{prefix}{name}"

		self:prototype[setter] = do |value|
			if this.@props[name] === value
				return

			this.dom[setter](value)
			this.@props[name] = value
			this.markDirty
			this

		setter

	defineProps ["Width", "Height"]
	defineProps ["Width", "Height"], prefix: 'Min'
	defineProps ["Width", "Height"], prefix: 'Max'
	defineProps ["Left", "Right", "Top", "Bottom"]
	defineProps ["Left", "Right", "Top", "Bottom"], prefix: 'Margin', combined: true
	defineProps ["Left", "Right", "Top", "Bottom"], prefix: 'Padding', combined: true
	defineProps ["Direction", "AlignItems", "AlignSelf", "AlignContent"]
	defineProps ["Flex", "Wrap"]
	defineProps ["Position"]

