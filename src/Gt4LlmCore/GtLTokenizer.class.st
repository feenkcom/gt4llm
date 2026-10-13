Class {
	#name : #GtLTokenizer,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Tokenization'
}

{ #category : #accessing }
GtLTokenizer >> tokenize: aString usingModel: aModel [
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
GtLTokenizer >> tokenizeMessages: aMessageGroup usingModel: aModel [
	^ self
		tokenize: ('' join: (aMessageGroup collect: #asTokenizableString))
		usingModel: aModel
]
