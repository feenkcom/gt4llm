Class {
	#name : #GtLSmaCCTransformationRemoveRuleTool,
	#superclass : #GtLSmaCCTransformationTool,
	#instVars : [
		'filename',
		'index'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #accessing }
GtLSmaCCTransformationRemoveRuleTool >> description [
	^ 'Removes the rewrite with id from a file.
	
Example JSON arguments:
{
	"filename": "./directory/rewrites.rw",
	"id": "04a85a15-226b-43e3-b483-96283609a533"
}

Example JSON response:
{
	"filename": "./directory/rewrites.rw",
	"oldRewriteId": "04a85a15-226b-43e3-b483-96283609a533",
	"newRewriteId": "00000000-0000-0000-0000-000000000000"
}
'
]

{ #category : #accessing }
GtLSmaCCTransformationRemoveRuleTool >> name [
	^ 'removeSmaCCRewrite'
]

{ #category : #execution }
GtLSmaCCTransformationRemoveRuleTool >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments removeRuleCall |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	removeRuleCall := arguments
			at: 'rewriteReference'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'rewriteReference' ].
	removeRuleCall model: model.
	removeRuleCall errorMessage
		ifNotNil: [ :msg | ^ GtLProblemDomainObject new errorMessage: msg ].
	^ removeRuleCall removeRewrite
]

{ #category : #accessing }
GtLSmaCCTransformationRemoveRuleTool >> rewriteFileDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #rewriteReference;
		classes: {GtLSmaCCTransformationRewriteReference};
		beRequired
]
