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
	| result processor parser transformationModel |
	parser := self smaccParser.
	parser
		ifNil: [ ^ GtLProblemDomainObject new
				description: 'Unknown parser: ' , self parserClass ].
	transformationModel := SmaCCTransformationToolkitModel new.
	transformationModel rewrites: self rewriteRulesFile.
	transformationModel inputParserClass: parser.
	result := SmaCCRewriteCompleteResult model: transformationModel.
	processor := SmaCCRewriteProcessor new.
	processor rules: transformationModel rewrites.
	processor parserClass: parser.
	processor processFile: self sourceFile usingResult: result.
	result outputSource
		ifNil: [ | fileSpec id errorMessage |
			errorMessage := result errorString.
			result transformation
				ifNotNil: [ :transformation | 
					fileSpec := model specificationFor: transformation parent filename.
					(fileSpec rules
						at: (transformation parent rewrites identityIndexOf: transformation)
						ifAbsent: [  ]) ifNotNil: [ :spec | id := spec id ] ].
			id
				ifNil: [ [ parser parse: self source ]
						on: Error
						do: [ :ex | errorMessage := 'Syntax error in input source to transform' ] ].
			^ GtLSmaCCTransformationRunnerException new
				message: errorMessage;
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
