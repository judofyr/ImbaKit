tag text < view
	useNodeClass 'ImbaTextNode'

	def setChildren child
		if !(child isa String)
			throw Error.new("<text> only accepts text")

		dom.setText(child)
		self