Extension { #name : #RBPullUpInstanceVariableRefactoring }

{ #category : #'*Gt4Llm-Refactoring' }
RBPullUpInstanceVariableRefactoring class >> llmDescription [
	<gtLlmTransformationDescription>
	^ GtLlmTransformationDescription new
		name: 'Pull up instance variable';
		description: 'The "Pull up instance variable" transformation pulls up instance variable definitions from subclasses into a superclass. The transformation must provide the className and variableName. The className specifies superclass that will define variableName after the transformation is executed.';
		example: {'className' -> 'FileSystemHandle'.
				'variableName' -> 'entry'} asDictionary;
		transformation: [ :model :dict | 
			self
				model: model
				variable: (dict at: 'variableName')
				class: (dict at: 'className') asSymbol ];
		yourself
]
