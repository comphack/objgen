([&]() -> bool
{
    if(@STREAM@.dynamicSizes.empty())
    {
            return false;
    }

    uint16_t elementCount = @STREAM@.dynamicSizes.front();
    @STREAM@.dynamicSizes.pop_front();

    @VAR_NAME@.clear();
    for(uint16_t i = 0; i < elementCount; ++i)
    {
            @VAR_TYPE@ element;

            if(!(@VAR_LOAD_CODE@))
            {
                return false;
            }

            @VAR_NAME@.push_back(element);
    }

    return @STREAM@.stream.good();
})()