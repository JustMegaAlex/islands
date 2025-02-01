
var dist = InstDist(oShip)
if dist < 200 {
    InstanceActivate(button, id)
} else {
    InstanceDeactivate(button, id)
} 

// if unseen and dist < oPlayerVision.vision_range {
//     unseen = false
//     if object_index == oScroll {
//         ArrayRemove(global.unseen_low_scrolls, id)
//     } else {
//         ArrayRemove(global.unseen_high_scrolls, id)
//     }
// }
