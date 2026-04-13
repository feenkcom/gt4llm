Class {
	#name : #GtLSmaCCTransformationGetRewriteFileTool,
	#superclass : #GtLSmaCCTransformationTool,
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #'as yet unclassified' }
GtLSmaCCTransformationGetRewriteFileTool >> description [
	^ 'Returns the rewrites in a file. Each rule will contain an id that can be used to directly reference the rule in add, remove, or update operations. The rules are listed in order that they occur in the file.
	
Example JSON arguments:
{
	"filename": "./directory/rewrites.rw"
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

{ #category : #'as yet unclassified' }
GtLSmaCCTransformationGetRewriteFileTool >> name [
	^ 'getSmaCCRewriteFile'
]

{ #category : #'as yet unclassified' }
GtLSmaCCTransformationGetRewriteFileTool >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments rewriteFileCall |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	rewriteFileCall := arguments
			at: 'rewriteFile'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'rewriteFile' ].
	rewriteFileCall model: model.
	^ GtLSmaCCTransformationGetRewriteFileResult new
		rewriteFile: rewriteFileCall rewriteFile;
		yourself
]

{ #category : #'as yet unclassified' }
GtLSmaCCTransformationGetRewriteFileTool >> rewriteFileDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #rewriteFile;
		classes: {GtLSmaCCTransformationFileReference};
		beRequired
]
