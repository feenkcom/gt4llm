Trait {
	#name : #TGtLDomainObject,
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
TGtLDomainObject >> acceptVisitor: aVisitor [
	^ self explicitRequirement
]

{ #category : #'api - testing' }
TGtLDomainObject >> isErrorDomainObject [
	"Return true if the response represents some kind of error, that happened during a tool execution."

	<return: #Boolean>
	^ self explicitRequirement
]

{ #category : #'api - serializing' }
TGtLDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ self explicitRequirement
]
