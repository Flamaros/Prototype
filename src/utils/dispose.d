module utils.disposable;

import core.runtime;

/*
 * An interface to make object's destruction deterministic
 */

interface Disposable
{
    void dispose();
}

bool handler( Object o )
{
    auto d = cast(Disposable) o;

    if( d !is null )
    {
        d.dispose();
        return false;
    }
    return true;
}

static this()
{
    Runtime.collectHandler = &handler;
}
