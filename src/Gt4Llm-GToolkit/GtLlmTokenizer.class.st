Class {
	#name : #GtLlmTokenizer,
	#superclass : #Object,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtLlmTokenizer >> tokenize: aString usingModel: aModel [
	| aTokenizerResult |
	PBApplication isRunning ifFalse: [ PBApplication start ].
	PBApplication uniqueInstance installModule: 'gtoolkit_tiktokenize'.

	aTokenizerResult := PBApplication
			do: [ :anApplication | 
				anApplication newCommandStringFactory
					bindingAt: #string put: aString;
					bindingAt: #model put: aModel;
					script: 'import gtoolkit_tiktokenize';
					resultExpression: 'gtoolkit_tiktokenize.tokenize(string, model)';
					sendAndWait ].

	^ aTokenizerResult
		input: aString;
		model: aModel
]

{ #category : #accessing }
GtLlmTokenizer >> tokenizeMessages: aMessageGroup usingModel: aModel [
	^ self
		tokenize: ('' join: (aMessageGroup collect: #asTokenizableString))
		usingModel: aModel
]
