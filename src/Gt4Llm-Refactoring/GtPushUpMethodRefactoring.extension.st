Extension { #name : #GtPushUpMethodRefactoring }

{ #category : #'*Gt4Llm-Refactoring' }
GtPushUpMethodRefactoring class >> llmDescription [
	<gtLlmTransformationDescription>
	^ GtLlmTransformationDescription new
		name: 'Push up method';
		description: 'The "Push up method" transformation pushes up a method from a subclass to its superclass. If the method exists in other sibling subclasses and is equivalently defined, the method will be removed from the sibling subclasses too. The transformation must provide the className and selector. The className is the name of a subclass that implements selector and is the version of the method that is being pushed up to the superclass.';
		example: {'className' -> 'Class'.
				'selector' -> 'absoluteName'} asDictionary;
		transformation: [ :model :dict | 
			self
				model: model
				pullUp: {(dict at: 'selector') asSymbol}
				from: (model classNamed: (dict at: 'className') asSymbol) ];
		yourself
]
