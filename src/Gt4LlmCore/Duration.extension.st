Extension { #name : #Duration }

{ #category : #'*Gt4LlmCore' }
Duration >> gtHumanReadableStringUpToMilliseconds [
	self = 0 seconds ifTrue: [ ^ '0s' ].
	self < 0 seconds ifTrue: [ ^ '-', self negated gtHumanReadableString ].
	
	self < 1 milliSecond ifTrue: [ ^ '< 1ms' ].
	
	self < 1 second ifTrue: [ ^ self wholeMilliseconds asString, 'ms' ].
	self < 1 minute ifTrue: [ 
		^ (self seconds asString, 's ')
				, (self wholeMilliseconds asString, 'ms') ].
				
	self < 1 hour ifTrue: [ 
		^ self minutes asString , 'm ', self seconds asString, 's' ].
		
	self < 1 day ifTrue: [ ^ self hours asString , 'h ', self minutes asString, 'm' ].
	self < 1 year ifTrue: [ ^ self days asString , 'd ', self hours asString, 'h' ].
	
	^ self printString
]
