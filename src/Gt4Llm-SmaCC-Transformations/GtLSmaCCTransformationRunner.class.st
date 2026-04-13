Class {
	#name : #GtLSmaCCTransformationRunner,
	#superclass : #GtLSmaCCTransformationFileReference,
	#instVars : [
		'parserClass',
		'source'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #accessing }
GtLSmaCCTransformationRunner >> parserClass [
	^ parserClass
]

{ #category : #accessing }
GtLSmaCCTransformationRunner >> parserClass: anObject [
	parserClass := anObject
]

{ #category : #accessing }
GtLSmaCCTransformationRunner >> parserClassDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #parserClass;
		comment: 'The SmaCC parser to use to parse the source before rewriting it.'
]

{ #category : #private }
GtLSmaCCTransformationRunner >> rewriteRulesFile [
	^ self rewriteFile asSmaCCRewriteIn: self model
]

{ #category : #actions }
GtLSmaCCTransformationRunner >> runRewrites [
	| result processor parser |
	parser := self smaccParser.
	parser
		ifNil: [ ^ GtLProblemDomainObject new
				description: 'Unknown parser: ' , self parserClass ].
	result := SmaCCRewriteCompleteResult model: self.
	processor := SmaCCRewriteProcessor new.
	processor rules: self rewriteRulesFile.
	processor parserClass: parser.
	processor processFile: self sourceFile usingResult: result.
	result outputSource
		ifNil: [ | fileSpec id |
			fileSpec := model specificationFor: result transformation parent filename.
			(fileSpec rules
				at: (result transformation parent rewrites identityIndexOf: result transformation)
				ifAbsent: [  ]) ifNotNil: [ :spec | id := spec id ].
			^ GtLSmaCCTransformationRunnerException new
				message: result errorString;
				rewriteId: id;
				line: result startLine;
				column: result startColumn;
				yourself ].
	^ GtLSmaCCTransformationResult new transformedSource: result outputSource
]

{ #category : #private }
GtLSmaCCTransformationRunner >> smaccParser [
	^ Smalltalk globals
		at: self parserClass asSymbol
		ifPresent: [ :cls | cls ]
		ifAbsent: [  ]
]

{ #category : #accessing }
GtLSmaCCTransformationRunner >> source [
	^ source
]

{ #category : #accessing }
GtLSmaCCTransformationRunner >> source: anObject [
	source := anObject
]

{ #category : #accessing }
GtLSmaCCTransformationRunner >> sourceDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #source;
		comment: 'The source to be transformed'
]

{ #category : #private }
GtLSmaCCTransformationRunner >> sourceFile [
	| sourceFile fs |
	fs := FileSystem memory root.
	sourceFile := fs / 'Source' / ('example' , self smaccParser fileExtension).
	sourceFile parent ensureCreateDirectory.
	sourceFile writeStreamDo: [ :stream | stream nextPutAll: self source ].
	^ sourceFile
]
