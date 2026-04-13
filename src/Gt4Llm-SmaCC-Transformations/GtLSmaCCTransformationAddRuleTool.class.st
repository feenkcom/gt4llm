Class {
	#name : #GtLSmaCCTransformationAddRuleTool,
	#superclass : #GtLSmaCCTransformationTool,
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #adding }
GtLSmaCCTransformationAddRuleTool >> addRewriteDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #addRewrite;
		classes: {GtLSmaCCTransformationAddRewrite};
		beRequired
]

{ #category : #accessing }
GtLSmaCCTransformationAddRuleTool >> description [
	^ 'Adds a rewrite to a file. It returns a reference to the new rewrite with its UUID. If the afterId is empty or a nil UUID, then it inserts the rule at the beginning.
	
Example JSON arguments:
{
	"filename": "./directory/rewrites.rw",
	"afterId": "04a85a15-226b-43e3-b483-96283609a533",
	"rewrite": {
		"comment": "This is a method rule",
		"source": "fortyTwo ^ 42"
	}
}

Example JSON response:
{
	"filename": "./directory/rewrites.rw",
	"oldRewriteId": "00000000-0000-0000-0000-000000000000",
	"newRewriteId": "433a2929-2fb9-4e88-89cf-00e0b33332ba"
}
'
]

{ #category : #accessing }
GtLSmaCCTransformationAddRuleTool >> name [
	^ 'addSmaCCRewrite'
]

{ #category : #execution }
GtLSmaCCTransformationAddRuleTool >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments addRewriteCall |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	addRewriteCall := arguments
			at: 'addRewrite'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'addRewrite' ].
	addRewriteCall model: model.
	addRewriteCall isValid
		ifFalse: [ ^ GtLMissingDomainObject new objectName: 'rewrite' ].
	^ addRewriteCall addRewrite
]
