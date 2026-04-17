Class {
	#name : #GtLSmaCCTransformationUpdateRuleTool,
	#superclass : #GtLSmaCCTransformationTool,
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #accessing }
GtLSmaCCTransformationUpdateRuleTool >> description [
	^ 'Updates a rewrite in a file. The `id` should contain the UUID of the rewrite rule that is to be updated obtained from the existing rule to modify. The `id` argument must be that existing rule''s UUID. Do not pass the nil UUID `00000000-0000-0000-0000-000000000000` as the id. Once the rewrite has been updated, it returns the newRewriteId of the updated rule that can be used in future calls to update or remove the rule in the future.
	
Example JSON arguments:
{
	"filename": "./directory/rewrites.rw",
	"id": "04a85a15-226b-43e3-b483-96283609a533",
	"rewrite": {
		"comment": "This is a method rule",
		"source": "fortyTwo ^ 42"
	}
}

Example JSON response:
{
	"filename": "./directory/rewrites.rw",
	"oldRewriteId": "04a85a15-226b-43e3-b483-96283609a533",
	"newRewriteId": "7a051cb5-bca5-48da-8439-b62eacff5c2a"
}
'
]

{ #category : #accessing }
GtLSmaCCTransformationUpdateRuleTool >> name [
	^ 'updateSmaCCRewrite'
]

{ #category : #execution }
GtLSmaCCTransformationUpdateRuleTool >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments updateRewriteCall |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	updateRewriteCall := arguments
			at: 'updateRewrite'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'updateRewrite' ].
	updateRewriteCall model: model.
	updateRewriteCall errorMessage
		ifNotNil: [ :msg | ^ GtLProblemDomainObject new errorMessage: msg ].
	^ updateRewriteCall updateRewrite
]

{ #category : #accessing }
GtLSmaCCTransformationUpdateRuleTool >> updateRewriteDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #updateRewrite;
		classes: {GtLSmaCCTransformationUpdateRewrite};
		beRequired
]
