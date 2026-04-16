Class {
	#name : #GtLSmaCCTransformationCreateRewriteFileTool,
	#superclass : #GtLSmaCCTransformationTool,
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #accessing }
GtLSmaCCTransformationCreateRewriteFileTool >> createRewriteFileDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #createRewriteFile;
		classes: {GtLSmaCCTransformationCreateFile};
		beRequired
]

{ #category : #accessing }
GtLSmaCCTransformationCreateRewriteFileTool >> description [
	^ 'Creates a new rewrite file. 
	
Example JSON arguments:
{
	"filename": "./directory/rewrites.rw",
	"parserClass": "JSParser"
}

Example JSON response:
{
	"rewriteFile": {
		"filename": "./directory/rewrites.rw",
		"parserClass": "JSParser",
		"rules": []
	}
}
'
]

{ #category : #accessing }
GtLSmaCCTransformationCreateRewriteFileTool >> name [
	^ 'createSmaCCRewriteFile'
]

{ #category : #execution }
GtLSmaCCTransformationCreateRewriteFileTool >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments createRewriteFileCall |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	createRewriteFileCall := arguments
			at: 'createRewriteFile'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'createRewriteFile' ].
	createRewriteFileCall model: model.
	createRewriteFileCall errorMessage
		ifNotNil: [ :msg | ^ GtLProblemDomainObject new errorMessage: msg ].
	^ GtLSmaCCTransformationGetRewriteFileResult new
		rewriteFile: createRewriteFileCall createRewriteFile;
		yourself
]
