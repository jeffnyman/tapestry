/*
This functionality will only work for browsers that support it.
See: http://caniuse.com/#feat=mutationobserver
*/

// WebDriver arguments, which are passed to the MutationObserver.
var element  = arguments[0];
var delay    = arguments[1] * 1000;
var callback = arguments[2];

/*
The two functions below are similar in what they are doing. Both are
disconneting the observer. Both are also invoking WebDriver's callback
function.

notStartedUpdating passes true to the callback, which indicates that the
DOM has not yet begun updating.

startedUpdating passes false to the callback, which indicates that the
DOM has begun updating.

The disconnect is important. You only want to be listening (observing) for the
period required, removing the listeners when done. Since there be many DOM
operations, you want to disconnet when there is interaction with the page by
the automated scripts.

When observing a node for changes, the callback will not be fired until the
DOM has finished changing. That is the only granularity that is required for
the Tapestry implementation. What specific events occurred is not important
because the goal is not to conditionally respond to them; rather just to know
when the process has completed.
*/
var notStartedUpdating = function() {
    return setTimeout(function() {
        observer.disconnect();
        callback(true);
    }, 1000);
};

var startedUpdating = function() {
    clearTimeout(notStartedUpdating);
    observer.disconnect();
    callback(false);
};

/*
Mutation Observer
The W3C DOM4 specification initially introduced mutation observers as a
replacement for the deprecated mutation events.

The MutationObserver is a JavaScript native object that allows for observing
a change on any node-like DOM Element. "Mutation" means the addition or the
removal of a node as well as changes to the node's attribute and data.

The general approach is to create a MutationObserver object with a defined
callback function. The function will execute on every mutation observed by
the MutationObserver. The MutationObserver must be bound to a target, which
for Tapestry would mean the element whose context it is being called upon.

A MutationObserver can be provided with a set of options, which indicate
what kind of events should be observed.

The childList option checks for additions and removals of the target node's
child elements, including text nodes. This is basically looking for any
nodes added or removed from documentElement.

The subtree option checks for mutations to the target as well the target's
descendants. So that means every child node of documentElement.

The attribute option checks for mutations to the target's attributes.

The characterData option checks for mutations to the target's data.
*/
var observer = new MutationObserver(startedUpdating);
var config = { attributes: true, childList: true, characterData: true, subtree: true };
observer.observe(element, config);

var notStartedUpdating = notStartedUpdating();
