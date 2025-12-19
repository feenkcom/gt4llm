Extension { #name : #RBAddMethodTransformation }

{ #category : #'*Gt4Llm-Refactoring' }
RBAddMethodTransformation class >> llmDescription [
	<gtLlmTransformationDescription>
	^ GtLlmTransformationDescription new
		name: 'Add method';
		description: 'The "Add method" transformation adds a method to a class. The transformation must provide the className, source, and protocol for the method.';
		example: {'className' -> 'Object'.
				'source' -> 'fortyTwo\	^42' withCRs.
				'protocol' -> 'accessing'} asDictionary;
		transformation: [ :model :dict | 
			self
				model: model
				sourceCode: (dict at: 'source')
				in: (model classNamed: (dict at: 'className') asSymbol)
				withProtocol: (dict at: 'protocol') asSymbol ];
		yourself
]
