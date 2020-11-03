import { ProxyNativeModule } from '@unimodules/core';
export interface ServerRegistrationModule extends ProxyNativeModule {
    getInstallationIdAsync?: () => Promise<string>;
    getLastRegistrationInfoAsync?: () => Promise<string>;
    setLastRegistrationInfoAsync?: (lastRegistrationInfo: string | null) => Promise<void>;
}
